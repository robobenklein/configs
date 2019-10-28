import os, subprocess, dotbot, pwd, grp

class Sync(dotbot.Plugin):
    '''
    Sync dotfiles
    '''

    _directive = 'sync'

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError('Sync cannot handle directive %s' % directive)
        return self._process_records(data)

    def _chmodown(self, path, chmod, uid, gid):
        os.chmod(path, chmod)
        os.chown(path, uid, gid)

    def _expand(self, path):
        return os.path.expandvars(os.path.expanduser(path))

    def _process_records(self, records):
        success = True
        defaults = self._context.defaults().get('sync', {})
        with open(os.devnull, 'w') as devnull:
            for destination, source in records.items():
                destination = self._expand(destination)
                rsync = defaults.get('rsync', 'rsync')
                options = defaults.get('options', ['--delete', '--safe-links'])
                create = defaults.get('create', False)
                fmode = defaults.get('fmode', 644)
                dmode = defaults.get('dmode', 755)
                owner = defaults.get('owner', pwd.getpwuid(os.getuid()).pw_name)
                group = defaults.get('group', grp.getgrgid(os.getgid()).gr_name)
                stdout = stderr = devnull
                if isinstance(source, dict):
                    # extended config
                    create = source.get('create', create)
                    rsync = source.get('rsync', rsync)
                    options = source.get('options', options)
                    fmode = source.get('fmode', fmode)
                    dmode = source.get('dmode', dmode)
                    owner = source.get('owner', owner)
                    group = source.get('group', group)
                    path = source['path']
                    if source.get('stdout', defaults.get('stdout', False)) is True:
                        stdout = None
                    if source.get('stderr', defaults.get('stderr', False)) is True:
                        stderr = None
                else:
                    path = source
                uid = pwd.getpwnam(owner).pw_uid
                gid = grp.getgrnam(group).gr_gid
                if create:
                    success &= self._create(destination, int('%s' % dmode, 8), uid, gid)
                path = self._expand(path)
                success &= self._sync(path, destination, dmode, fmode, owner, group, rsync, options, stdout, stderr)
        if success:
            self._log.info('All synchronizations have been done')
        else:
            self._log.error('Some synchronizations were not successful')
        return success

    def _create(self, path, dmode, uid, gid):
        success = True
        parent = os.path.abspath(os.path.join(path, os.pardir))
        if not os.path.exists(parent):
            try:
                os.mkdir(parent, dmode)
                self._chmodown(parent, dmode, uid, gid)
            except Exception as e:
                self._log.warning('Failed to create directory %s. %s' % (parent, e))
                success = False
            else:
                self._log.lowinfo('Creating directory %s' % parent)
        return success

    def _sync(self, source, destination, dmode, fmode, owner, group, rsync, options, stdout, stderr):
        '''
        Synchronizes source to destination

        Returns true if successfully synchronized files.
        '''
        success = False
        source = os.path.join(self._context.base_directory(), source)
        destination = os.path.expanduser(destination)
        try:
            cmd = [rsync,
                    '--update',
                    '--recursive',
                    '--group',
                    '--owner',
                    '--chown=%s:%s' % (owner, group),
                    '--chmod=D%s,F%s' % (dmode, fmode)]
            if os.path.isdir(source):
                source = '%s/' % source
            ret = subprocess.call(cmd + options + [source, destination],
                    stdout=stdout, stderr=stderr, cwd=self._context.base_directory())
            if ret != 0:
                self._log.warning('Failed to sync %s -> %s' % (source, destination))
            else:
                success = True
                self._log.lowinfo('Synchronized %s -> %s' % (source, destination))
        except Exception as e:
            self._log.warning('Failed to sync %s -> %s. %s' % (source, destination, e))
        return success
