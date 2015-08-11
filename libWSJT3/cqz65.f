C
C      Copyright (c) 2010 Joe Large W4CQZ
C      based upon wsjt65.f which is;
C      (c) 2001-2009 by Joseph H. Taylor, Jr., K1JT, with
C      contributions from additional authors.
C
C      License:  V2 GPL
C
      subroutine cqz65(dat,npts,DFTolerance,NAFC,MouseDF,idf,mline,
     +                 ical,wisfile,kvfile)

C     Orchestrates the process of decoding JT65 messages, using data
C     that have been 2x downsampled.  The search for shorthand messages
C     has already been done.

      real dat(npts)                        !Raw data
      integer DFTolerance
      logical first
      character decoded*22,special*5
      character*22 avemsg1,avemsg2,deepmsg
      character*67 line,ave1,ave2,line2
      character*1 csync,c1
      character*12 mycall
      character*12 hiscall
      character*6 hisgrid
      character*67 mline
      character*255 wisfile
      character*255 kvfile
      real ccfblue(-5:540),ccfred(-224:224)
	integer NFreeze

!      print *,'In cqz65.f...'
!      print *,kvfile

      NFreeze=1
      NClearAve=1
      mode65=1
      MinSigDB=1
      ndepth=0 ! Standard decode, no deep search enabled.
      neme=0
      naggressive=0
      nstest=0
      ndiag=0
      mycall='            '
      hiscall='            '
      hisgrid='      '

      csync=' '
      decoded='                      '
      deepmsg='                      '
      special='     '
      line=''
      line2=''
      mline=''
      ncount=-1             !Flag for RS decode of current record
      NSyncOK=0
      nqual1=0
      nqual2=0

      call setup65                !Initialize pseudo-random arrays

C     Attempt to synchronize: look for sync tone, get DF and DT.

      call sync65(dat,npts,DFTolerance,NFreeze,MouseDF,
     +    mode65,dtx,dfx,snrx,snrsync,ccfblue,ccfred,flip,width,ical,
     +    wisfile)

      nsync=nint(snrsync-3.0)
      nsnr=nint(snrx)
      if(nsnr.lt.-30 .or. nsync.lt.0) nsync=0
      nsnrlim=-32

      if(nsync.lt.MinSigdB .or. nsnr.lt.nsnrlim) go to 200

C     If we get here, we have achieved sync!

      csync='*'
      if(flip.lt.0.0) csync='#'

      call decode65(dat,npts,dtx,dfx,flip,ndepth,neme,
     +   mycall,hiscall,hisgrid,mode65,nafc,decoded,
     +   ncount,deepmsg,qual,ical,wisfile,kvfile)

      if(ncount.eq.-999) qual=0                 !Bad data

 200  kvqual=0

      ndf=nint(dfx)
      jdf=ndf+idf

C      write(line,1010) nsync,',',nsnr,',',dtx-1.0,',',jdf,',',
C     +    nint(width),',',csync,',',decoded(1:19)

      write(line,2020) jdf,',',nsync,',',nsnr,',',dtx-1.0,',',
     +    csync,',',decoded(1:21)

C 1010 format(i3,a1,i3,a1,f4.1,a1,i5,a1,i2,a1,a1,a1,a19)

 2020 format(i5,a1,i3,a1,i3,a1,f4.1,a1,a1,a1,a21)

      mline=line(1:43)

C      print *,line

 900  continue

      return
      end
