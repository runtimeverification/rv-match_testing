
- SSH
    ssh [-p (2222|6666)] username@office.runtimeverification.com

- VirtualBox
    To reset clipboard, run this in the VM:
    pkill 'VBoxClient --clipboard' -f & sleep 1 && VBoxClient --clipboard

- Update RV Match
    wget https://runtimeverification.com/match/upgrade.sh -O upgrade.sh && sh upgrade.sh

- kcc flags
    -no-pedantic		Shows if GNU extensions are used.
    -std=gnu11			
    -fno-native-compilation	

- k-bin-to-text dependencies
    sudo apt update
    sudo apt -y install build-essential m4 openjdk-8-jdk libgmp-dev libmpfr-dev pkg-config flex z3 maven opam
    git clone https://github.com/runtimeverification/rv-match.git
    In rv-match/k/, run "mvn package -DskipTests"
    Make sure that the PATH variable points to `rv-match/k/k-distribution/target/release/k/bin`
    Run `kserver &` (& runs something in the background)

- Project finding suggestions

    Debian has a quite good package manager and good package metadata for all the packages contained in Debian.
    So you should be able to filter (automatically) all the packages coded in C.
    And they all have a precise configuration and can be built from source.
    (Of course I'm thinking of the free sub-collection of packages)
    So you probably can find the (thousands) of Debian packages coded in C. This is quite easy in principle.
    From that large subset, you can use the Debian popularity contest.
    So you can automatically order them by your popularity criteria.
    You then find a significant collection of Debian packages, coded in C, and popular. And you find that set automatically.

    Have you tried testing standard Unix programs (e.g., ps, kill, etc)? Their embedded counterparts in Busybox? And perhaps C standard libraries for embedded system (e.g., musl)?
    Another thing you might want to do is to check the bug finding papers from security conferences and see what projects are used.

    The linux kernel, glibc, libg++, Apache, and nginx. The Windows kernel. The OS X kernel.
    GCC. Python (which is written in C). Anything you find in any .so file on a Linux system, or inside a framework bundle on a Mac.


- Deprecated list of projects


    2           del        ifconfig      modprobe     setfiles         top
    acpid       devfs.h    ifupdown      modutils     setfont          topmem.h
    adduser     devpts.h   individual.h  mount        setpriv          touch
    aix         df         inetd         mtab         sgi              tr
    allow       diff       init          nameif       sh               traceroute
    ar          dmesg      insmod        netstat      shadowpasswds.h  tunctl
    awk         du         install       nologin.h    shared           udhcp
    beep        editing    installer.h   non          show             udhcpc
    blkid       editing.h  ip            ntpd         skip             udhcpc6
    bootchartd  eject      ipc           osf          sort             udhcpd
    brctl       etc        ipcalc        passwd       split            umount
    buffers     fancy      ipv6.h        pidfile.h    start            unix
    bzip2       fast       kill          pidof        stat             unzip
    call        fbset      klogd         popmaildir   su               uptime
    catn.h      fdisk      kmsg          powertop     suid             use
    catv.h      find       last          prefer       suid.h           username
    chat        float      less          preserve     sun              utmp.h
    check       ftpd       libbusybox    ps           swapon           verbose
    chown       ftpgetput  loadfont      readlink     swaponoff        verbose.h
    clean       getopt     logread       reformime    sync             vi
    cmdline     gpt        ls            remote       syslogd          volumeid
    compress    grep       lsmod         resize       syslog.h         wc
    copybuf     gunzip     lzma          reverse      tab              wget
    cp          gzip       makedevs      rotate       tar              wtmp.h
    cpio        hdparm     md5           rtminmax.h   taskset          xargs
    crond       hexdump    mdev          run          tee
    date        httpd      mesg          runsvdir     telnet
    dc          human      mime          seamless     telnetd
    dd          hwclock    minix2.h      securetty.h  test
    default     hwib.h     mkswap        setconsole   tftp

    [, [[, acpid, addgroup, adduser, adjtimex, ar, arp, arping, ash,
        awk, basename, beep, blkid, brctl, bunzip2, bzcat, bzip2, cal, cat,
        catv, chat, chattr, chgrp, chmod, chown, chpasswd, chpst, chroot,
        chrt, chvt, cksum, clear, cmp, comm, cp, cpio, crond, crontab,
        cryptpw, cut, date, dc, dd, deallocvt, delgroup, deluser, depmod,
        devmem, df, dhcprelay, diff, dirname, dmesg, dnsd, dnsdomainname,
        dos2unix, dpkg, du, dumpkmap, dumpleases, echo, ed, egrep, eject,
        env, envdir, envuidgid, expand, expr, fakeidentd, false, fbset,
        fbsplash, fdflush, fdformat, fdisk, fgrep, find, findfs, flash_lock,
        flash_unlock, fold, free, freeramdisk, fsck, fsck.minix, fsync,
        ftpd, ftpget, ftpput, fuser, getopt, getty, grep, gunzip, gzip, hd,
        hdparm, head, hexdump, hostid, hostname, httpd, hush, hwclock, id,
        ifconfig, ifdown, ifenslave, ifplugd, ifup, inetd, init, inotifyd,
        insmod, install, ionice, ip, ipaddr, ipcalc, ipcrm, ipcs, iplink,
        iproute, iprule, iptunnel, kbd_mode, kill, killall, killall5, klogd,
        last, length, less, linux32, linux64, linuxrc, ln, loadfont,
        loadkmap, logger, login, logname, logread, losetup, lpd, lpq, lpr,
        ls, lsattr, lsmod, lzmacat, lzop, lzopcat, makemime, man, md5sum,
        mdev, mesg, microcom, mkdir, mkdosfs, mkfifo, mkfs.minix, mkfs.vfat,
        mknod, mkpasswd, mkswap, mktemp, modprobe, more, mount, mountpoint,
        mt, mv, nameif, nc, netstat, nice, nmeter, nohup, nslookup, od,
        openvt, passwd, patch, pgrep, pidof, ping, ping6, pipe_progress,
        pivot_root, pkill, popmaildir, printenv, printf, ps, pscan, pwd,
        raidautorun, rdate, rdev, readlink, readprofile, realpath,
        reformime, renice, reset, resize, rm, rmdir, rmmod, route, rpm,
        rpm2cpio, rtcwake, run-parts, runlevel, runsv, runsvdir, rx, script,
        scriptreplay, sed, sendmail, seq, setarch, setconsole, setfont,
        setkeycodes, setlogcons, setsid, setuidgid, sh, sha1sum, sha256sum,
        sha512sum, showkey, slattach, sleep, softlimit, sort, split,
        start-stop-daemon, stat, strings, stty, su, sulogin, sum, sv,
        svlogd, swapoff, swapon, switch_root, sync, sysctl, syslogd, tac,
        tail, tar, taskset, tcpsvd, tee, telnet, telnetd, test, tftp, tftpd,
        time, timeout, top, touch, tr, traceroute, true, tty, ttysize,
        udhcpc, udhcpd, udpsvd, umount, uname, uncompress, unexpand, uniq,
        unix2dos, unlzma, unlzop, unzip, uptime, usleep, uudecode, uuencode,
        vconfig, vi, vlock, volname, watch, watchdog, wc, wget, which, who,
        whoami, xargs, yes, zcat, zcip


    sqlite, qmail, Bernstein: djbdns, Salsa20, Poly1305, Curve25519
    vi, makefs, sh, fdisk, installboot, make (BSD version), awk

    Temporary focus:
    awk								https://github.com/onetrueawk/awk.git
    => bind9			gcc, kcc issue 548		git clone https://source.isc.org/git/bind9.git
    => coreutils		gcc, kcc issues 559, 570	http://ftp.gnu.org/gnu/coreutils/coreutils-8.28.tar.xz
    => openssl			gcc, kcc issue 547		https://github.com/openssl/openssl/commit/7a908204ed3afe1379151c6d090148edb2fcc87e


    project			status				source

    => bind9			gcc, kcc issue 548		git clone https://source.isc.org/git/bind9.git

    bozohttpd			not downloaded			http://www.eterna.com.au/bozohttpd/
    C-Sorts								https://github.com/shekkbuilder/C-Sorts/pull/1
    cat				_simple_
    catimg			gcc & kcc			External: https://github.com/posva/catimg/issues/31
    cineform-sdk		gcc, kcc issue 546		https://github.com/gopro/cineform-sdk/commit/81c9eb118a4f2a03a3194098623f0cbfd85f3561

    => coreutils		gcc, kcc issues 559, 570	http://ftp.gnu.org/gnu/coreutils/coreutils-8.28.tar.xz

    cp				_simple_
    curl
    CVE
    darknet
    FFmpeg			gcc, kcc issue 541		https://github.com/FFmpeg/FFmpeg/commit/acf70639fb534a4ae9b1e4c76153f0faa0bda190
    git
    hashcat			gcc, kcc issue 564		git clone https://github.com/hashcat/hashcat.git
    leetcode 							https://github.com/begeekmyfriend/leetcode.git
    libuv			gcc, kcc issue 555		https://github.com/libuv/libuv/commit/719dfecf95b0c74af6494f05049e56d5771ebfae
    linux
    ls				_simple_
    mbedtls			gcc, kcc issue 558		https://tls.mbed.org/download/mbedtls-2.4.0-gpl.tgz
    mDNSResponder		downloaded......		https://opensource.apple.com/tarballs/mDNSResponder/
    mv				gcc, kcc did not with -ansi	External: https://github.com/singpolyma/mv/issues/1
    netdata			gcc, kcc issue 544		https://github.com/firehol/netdata/commit/2bbde1ba150b0d6fb66cd01d94b26da0181fd45e
    nginx
    numpy

    => openssl			gcc, kcc issue 547		https://github.com/openssl/openssl/commit/7a908204ed3afe1379151c6d090148edb2fcc87e

    pg_blkchain
    php-src
    Remotery			gcc, kcc issue 571		https://github.com/Celtoys/Remotery/commit/4070513159ff3a72f12a47a249ce0e51abf19c34
    Reptile			gcc, kcc issue 572		https://github.com/f0rb1dd3n/Reptile/commit/1bd1872315440c2c08d33f4470989b575e8293a6
    rm				_simple_
    scv-1.0p2-sysc2.2
    seL4
    shadowsocks-libev		see status of dependency "mbedtls"
    systemc-2.3			gcc, not kcc & k++
    tar				fail on gcc see issue		External: https://github.com/calccrypto/tar/issues/1
    tmux			gcc, kcc issue 552		https://github.com/tmux/tmux/commit/cf782c4f546fb11f3157de7aecff85845b0dbed9
    The-Art-Of-Programming-By-July
    vi								https://github.com/satran/vi.git
    vim
    wget			gcc, not kcc			git clone https://github.com/mirror/wget.git

    wrk
    ZFSin
