// This scripts relies on two things:
// 1. `workspace.desktops` and `client.desktops` giving me desktops in the same
//    order as in pager and all context menus
// 2. Desktops being comparable for equality with `==` operator
// Desktop numbers are from zero (unlike how it worked in plasma 5)

const MIN_DESKTOPS = 2;
const LOG_LEVEL = 2; // 0 trace, 1 debug, 2 info

function log(...args) {
  print("[dynamic_workspaces] ", ...args);
}
function debug(...args) {
  if (LOG_LEVEL <= 1) log(...args);
}
function trace(...args) {
  if (LOG_LEVEL <= 0) log(...args);
}

// In plasma 6 simply removing a desktop breaks the desktop switching
// animation. We use a workaround with emitting more switches at the right time
// to force the animation to play.
let animationFixup = false;

/***** Plasma 5/6 differences *****/
const isKde6 = typeof workspace.windowList === "function";
const compat = isKde6
  ? {
      addDesktop: () => {
        workspace.createDesktop(workspace.desktops.length, undefined);
      },
      windowAddedSignal: (ws) => ws.windowAdded,
      windowList: (ws) => ws.windowList(),
      desktopChangedSignal: (c) => c.desktopsChanged,
      toDesktop: (d) => d,
      workspaceDesktops: () => workspace.desktops,
      lastDesktop: () => workspace.desktops[workspace.desktops.length - 1],
      deleteLastDesktop: () => {
        try {
          animationFixup = true;
          const last = workspace.desktops[workspace.desktops.length - 1];
          const current = workspace.currentDesktop;
          const index = workspace.desktops.indexOf(current);
          const target = index + 1 < workspace.desktops.length || index === -1
            ? workspace.desktops[index + 1]
            : current;
          workspace.currentDesktop = target;
          workspace.removeDesktop(last);
          workspace.currentDesktop = current;
        } finally {
          animationFixup = false;
        }
      },
      findDesktop: (ds, d) => ds.indexOf(d),
      clientDesktops: (c) => c.desktops,
      setClientDesktops: (c, ds) => {
        c.desktops = ds;
      },
      clientOnDesktop: (c, d) => c.desktops.indexOf(d) !== -1,
    }
  : {
      addDesktop: () => {
        workspace.createDesktop(workspace.desktops, "dyndesk");
      },
      windowAddedSignal: (ws) => ws.clientAdded,
      windowList: (ws) => ws.clientList(),
      desktopChangedSignal: (c) => c.desktopChanged,
      toDesktop: (number) => ({ index: number - 1 }),
      workspaceDesktops: () => {
        const result = [];
        for (let i = 0; i < workspace.desktops; ++i) {
          result.push({ index: i });
        }
        return result;
      },
      lastDesktop: () => ({ index: workspace.desktops - 1 }),
      deleteLastDesktop: () => {
        workspace.removeDesktop(workspace.desktops - 1);
      },
      findDesktop: (ds, d) => {
        for (let i = 0; i < ds.length; ++i) {
          if (ds[i].index === d.index) return i;
        }
        return -1;
      },
      clientDesktops: (c) => c.x11DesktopIds.map((id) => ({ index: id - 1 })),
      setClientDesktops: (c, ds) => {
        c.desktop = ds[0];
      },
      clientOnDesktop: (c, d) => c.desktop === d.index + 1,
    };

/***** Logic definition *****/
function shiftRighterThan(client, number) {
  trace(`shiftRighterThan(${client.caption}, ${number})`);
  if (number === 0) return;

  const allDesktops = compat.workspaceDesktops();
  const clientDesktops = compat.clientDesktops(client);
  const newDesktops = [];
  let i = 0;

  for (const d of clientDesktops) {
    while (d != allDesktops[i]) {
      i += 1;
      if (i > allDesktops.length) throw new Error("Desktop equality behavior changed");
    }
    if (i < number || i === 0) {
      newDesktops.push(d);
    } else {
      newDesktops.push(allDesktops[i - 1]);
    }
  }
  compat.setClientDesktops(client, newDesktops);
}

function removeDesktop(number) {
  trace(`removeDesktop(${number})`);
  const desktopsLength = compat.workspaceDesktops().length;
  if (desktopsLength - 1 <= number) {
    debug("Not removing desktop at end");
    return false;
  }
  if (desktopsLength <= MIN_DESKTOPS) {
    debug("Not removing desktop, too few left");
    return false;
  }

  compat.windowList(workspace).forEach((client) => {
    shiftRighterThan(client, number);
  });
  compat.deleteLastDesktop();
  debug("Desktop removed");
  return true;
}

function isEmptyDesktop(number) {
  trace(`isEmptyDesktop(${number})`);
  const desktop = compat.workspaceDesktops()[number];
  const clients = compat.windowList(workspace);
  for (const client of clients) {
    if (
      compat.clientOnDesktop(client, desktop) &&
      !client.skipPager &&
      !client.onAllDesktops
    ) {
      debug(`Desktop ${number} not empty because ${client.caption} is there`);
      return false;
    }
  }
  return true;
}

function onDesktopChangedFor(client) {
  trace(`onDesktopChangedFor(${client.caption})`);
  const lastDesktop = compat.lastDesktop();
  if (compat.clientOnDesktop(client, lastDesktop)) {
    compat.addDesktop();
  }
}

function onClientAdded(client) {
  if (client === null) {
    log("onClientAdded(null) - that may happen rarely");
    return;
  }
  trace(`onClientAdded(${client.caption})`);
  if (client.skipPager) {
    debug("Ignoring added hidden window");
    return;
  }
  if (compat.clientOnDesktop(client, compat.lastDesktop())) {
    compat.addDesktop();
  }
  compat.desktopChangedSignal(client).connect(() => {
    onDesktopChangedFor(client);
  });
}

function onDesktopSwitch(oldDesktop) {
  trace(`onDesktopSwitch(${oldDesktop})`);
  if (animationFixup) return;

  const allDesktops = compat.workspaceDesktops();
  const oldDesktopIndex = compat.findDesktop(allDesktops, compat.toDesktop(oldDesktop));
  const currentDesktopIndex = compat.findDesktop(allDesktops, compat.toDesktop(workspace.currentDesktop));
  const getDesktopsLength = () => compat.workspaceDesktops().length;
  const keepEmptyMiddleDesktops = readConfig("keepEmptyMiddleDesktops", false);

  if (oldDesktopIndex <= currentDesktopIndex) {
    debug("Desktop switched to the right - ignoring");
    return;
  }

  for (
    let desktopIdx = getDesktopsLength() - 2;
    desktopIdx > currentDesktopIndex && desktopIdx > 0;
    --desktopIdx
  ) {
    debug(`Examine desktop ${desktopIdx}`);
    if (isEmptyDesktop(desktopIdx)) {
      removeDesktop(desktopIdx);
    } else if (keepEmptyMiddleDesktops) {
      debug("Found non-empty desktop, stopping purge");
      break;
    }
  }
}

compat.windowList(workspace).forEach(onClientAdded);
compat.windowAddedSignal(workspace).connect(onClientAdded);
workspace.currentDesktopChanged.connect(onDesktopSwitch);
