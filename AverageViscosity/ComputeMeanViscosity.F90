      PROGRAM  ComputeMeanViscosity
      use NETCDF
      implicit none
      INTEGER, PARAMETER :: MAX_NAME_LEN = 128
      INTEGER, PARAMETER :: dp = SELECTED_REAL_KIND(12)


      real(kind=dp),allocatable :: xx(:),yy(:),zz(:),T(:)
      real(kind=dp) :: mubar,Tmean
      real(kind=dp),parameter :: NoVal=-1.0e10
      integer :: nx,ny,nz

      integer :: i,j,k

      CHARACTER(LEN=MAX_NAME_LEN):: FName,OName
      CHARACTER(LEN=MAX_NAME_LEN):: xdimName='x',ydimName='y', &
                                    zdimName='z'
      CHARACTER(LEN=MAX_NAME_LEN):: xvarName='x',yvarName='y', &
                                    zvarName='z'
      CHARACTER(LEN=MAX_NAME_LEN):: TvarName='Temperature'
      LOGICAL :: TinCelsius=.FALSE.
      INTEGER :: NetCDFstatus
      INTEGER :: ncid,varid
      INTEGER :: noid,xoid,yoid,Tid,Muid
      INTEGER :: xdimid,ydimid

      real(kind=dp) :: A1=8.9837442100152e12,A2=7.43393850060239e+23
      real(kind=dp) :: Q1=60.0e03,Q2=115.0e03
      real(kind=dp) :: Tlimit=263.15
      real(kind=dp) :: EhF=1._dp
      real(kind=dp) :: Glen_n=3._dp
      real(kind=dp) :: R=8.314_dp

      NAMELIST /FILE/FName,OName,&
                     xdimName,ydimName,zdimName,&
                     xvarName,yvarName,zvarName,&
                     TvarName,TinCelsius

      OPEN(12, file='input.txt', form='formatted', status='old')
      READ(12, nml=FILE)
      CLOSE(12)

      WRITE(*,*) ' '
      WRITE(*,*) '*** File informations'
      WRITE(*,FILE) 
      WRITE(*,*) ' '

!! Initialize Glen parameters
      call GlenParameters()

!! Get nx,ny,nz
      NetCDFstatus = NF90_OPEN(trim(FName),NF90_NOWRITE,ncid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'can not open ',trim(FName)
         stop
      END IF
      NetCDFstatus = nf90_inq_dimid(ncid, trim(xdimName) , varid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to get x dim id'
         stop
      END IF
      NetCDFstatus = nf90_inquire_dimension(ncid,varid,len=nx)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to get nx'
         stop
      END IF
      NetCDFstatus = nf90_inq_dimid(ncid, trim(ydimName) , varid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to get y dim id'
         stop
      END IF
      NetCDFstatus = nf90_inquire_dimension(ncid,varid,len=ny)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to get ny'
         stop
      END IF
      NetCDFstatus = nf90_inq_dimid(ncid, trim(zdimName) , varid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to get z dim id'
         stop
      END IF
      NetCDFstatus = nf90_inquire_dimension(ncid,varid,len=nz)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to get nz'
         stop
      END IF
 
!! 
      allocate(xx(nx),yy(ny),zz(nz),T(nz))
      NetCDFstatus = nf90_inq_varid(ncid,trim(xvarName),varid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to get x varid'
         stop
      END IF
      NetCDFstatus = nf90_get_var(ncid, varid,xx)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
        PRINT *, 'unable to get x'
         stop
      ENDIF
      NetCDFstatus = nf90_inq_varid(ncid,trim(yvarName),varid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to get y varid'
         stop
      END IF
      NetCDFstatus = nf90_get_var(ncid, varid,yy)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
        PRINT *, 'unable to get y'
         stop
      ENDIF
      NetCDFstatus = nf90_inq_varid(ncid,trim(zvarName),varid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to get z varid'
         stop
      END IF
      NetCDFstatus = nf90_get_var(ncid, varid,zz)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
        PRINT *, 'unable to get z'
         stop
      ENDIF
      NetCDFstatus = nf90_inq_varid(ncid,trim(TvarName),varid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to get Temperature varid'
         stop
      END IF

!! Create output file
      NetCDFstatus = nf90_create(trim(OName),nf90_clobber,noid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to create output file'
         stop
      ENDIF
      NetCDFstatus = nf90_def_dim(noid, 'x', nx, xdimid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to create output file dim x'
         stop
      ENDIF
      NetCDFstatus = nf90_def_dim(noid, 'y', ny, ydimid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to create output file dim y'
         stop
      ENDIF
      NetCDFstatus = nf90_def_var(noid, 'Tmean' , NF90_DOUBLE,  (/xdimid,ydimid/), Tid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to create output file var Tmean'
         stop
      ENDIF
      NetCDFstatus = nf90_put_att(noid, Tid, '_FillValue',NoVal)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to create  Tmean attribute _FillValue '
         stop
      ENDIF
      NetCDFstatus = nf90_def_var(noid, 'Mumean' , NF90_DOUBLE,  (/xdimid,ydimid/), Muid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to create output file var Mumean'
         stop
      ENDIF
      NetCDFstatus = nf90_put_att(noid, Muid, '_FillValue',NoVal)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to create  Tmean attribute _FillValue '
         stop
      ENDIF
      NetCDFstatus = nf90_def_var(noid, 'x' , NF90_DOUBLE,  xdimid, xoid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to create output file var x'
         stop
      ENDIF
      NetCDFstatus = nf90_def_var(noid, 'y' , NF90_DOUBLE,  ydimid, yoid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to create output file var y'
         stop
      ENDIF
      NetCDFstatus = nf90_put_att(noid,NF90_GLOBAL,'input file',trim(FName))
      NetCDFstatus = nf90_put_att(noid,NF90_GLOBAL,'A1',A1)
      NetCDFstatus = nf90_put_att(noid,NF90_GLOBAL,'A2',A2)
      NetCDFstatus = nf90_put_att(noid,NF90_GLOBAL,'Q1',Q1)
      NetCDFstatus = nf90_put_att(noid,NF90_GLOBAL,'Q2',Q2)
      NetCDFstatus = nf90_put_att(noid,NF90_GLOBAL,'Tlimit',Tlimit)
      NetCDFstatus = nf90_put_att(noid,NF90_GLOBAL,'E',Ehf)
      NetCDFstatus = nf90_put_att(noid,NF90_GLOBAL,'Glen_index',Glen_n)
      NetCDFstatus = nf90_put_att(noid,NF90_GLOBAL,'R',R)

      NetCDFstatus = nf90_enddef(noid)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to enddef output file' 
         stop
      ENDIF

      NetCDFstatus = nf90_put_var(noid,xoid,xx)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to put x in output file' 
         stop
      ENDIF
      NetCDFstatus = nf90_put_var(noid,yoid,yy)
      IF ( NetCDFstatus /= NF90_NOERR ) THEN
         PRINT *, 'unable to put y output file' 
         stop
      ENDIF

      Do i=1,nx
        Do j=1,ny
         NetCDFstatus = nf90_get_var(ncid, varid,T,start=(/i,j,1/),count=(/1,1,nz/))
         IF (TinCelsius) T=T+273.15
         IF ( NetCDFstatus /= NF90_NOERR ) THEN
           PRINT *, 'unable to get Temperature at point',i,j
           stop
         END IF
         IF (ANY(T<=200.0_dp).OR.ANY(T>=280.0_dp)) then
            Tmean=NoVal
            mubar=NoVal
         ELSE
            Tmean=0._dp
            mubar=0._dp
            Do k=1,nz-1
              mubar=mubar+0.5*(Mu(T(k))+Mu(T(k+1)))*(zz(k+1)-zz(k))
              Tmean=Tmean+0.5*(T(k)+T(k+1))*(zz(k+1)-zz(k))
            End do
         ENDIF
         NetCDFstatus = &
            nf90_put_var(noid,Tid,Tmean,start=(/i,j/))
         IF ( NetCDFstatus /= NF90_NOERR ) THEN
           PRINT *, 'unable to put Tmean at point',i,j
           stop
         END IF
         NetCDFstatus = &
            nf90_put_var(noid,muid,mubar,start=(/i,j/))
         IF ( NetCDFstatus /= NF90_NOERR ) THEN
           PRINT *, 'unable to put mubar at point',i,j
           stop
         END IF
        End do
      End do


!!
      NetCDFstatus = nf90_close(ncid)
      NetCDFstatus = nf90_close(noid)
      deallocate(xx,yy,zz,T)

      CONTAINS

      SUBROUTINE GlenParameters
      implicit none

      NAMELIST /Glen_input/A1,A2,Q1,Q2,Tlimit,EhF,Glen_n,R

      OPEN(12, file='input.txt', form='formatted', status='old')
      READ(12, nml=Glen_input)
      CLOSE(12)

      WRITE(*,*) ' '
      WRITE(*,*) '*** Ice flow law parameters :'
      WRITE(*,Glen_input)
      WRITE(*,*) ' '

      END SUBROUTINE GlenParameters

      FUNCTION Mu(T) RESULT(Viscosity)
      implicit none
      real(kind=dp) :: T,Viscosity
      real(kind=dp) :: ArrheniusFactor

        IF (T.LE.Tlimit) THEN
          ArrheniusFactor = A1 * EXP( -Q1/(R * T ))
        ELSE IF((T.GT.Tlimit) .AND. (T .LE. 273.15_dp)) THEN
          ArrheniusFactor = A2 * EXP( -Q2/(R * T ))
        ELSE
          ArrheniusFactor = A2 * EXP( -Q2/(R * 273.15_dp))
        ENDIF
        Viscosity=(2.0*EhF*ArrheniusFactor)**(-1.0/Glen_n)
      END FUNCTION Mu

      END
