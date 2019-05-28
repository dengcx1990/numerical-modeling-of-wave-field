Subroutine Wave_Field_Modeling(delt_x,delt_z,delt_h,reflect_coefficient,fre_wavelet,delay_source_t0,nt,delt_t,&
                               n_source,ige,ig1,ig2,nx,nz,ml,is,js,Input_file_modelpar,Output_file_snapx,&
                               Output_file_snapz,Output_file_recordx,Output_file_recordz)
  Implicit None
  Real :: delt_x,delt_z,delt_h
  Real :: reflect_coefficient
  Real :: fre_wavelet,delay_source_t0
  Integer :: nt
  Real :: delt_t
  Integer :: n_source
  Real :: ige,ig1,ig2
  Integer :: nx,nz,ml
  Integer :: is,js
  Character *(*) :: Input_file_modelpar
  Character *(*) :: Output_file_snapx,Output_file_snapz
  Character *(*) :: Output_file_recordx,Output_file_recordz
  Real :: c11(-ml:nx+ml,-ml:nz+ml),c13(-ml:nx+ml,-ml:nz+ml),&
          c33(-ml:nx+ml,-ml:nz+ml),c44(-ml:nx+ml,-ml:nz+ml)       !VTI���ʵ��Գ���
  Real :: density(-ml:nx+ml,-ml:nz+ml)
  Real :: vp(-ml:nx+ml,-ml:nz+ml),vs(-ml:nx+ml,-ml:nz+ml)
  Real :: vx(-ml:nx+ml,-ml:nz+ml,2),vz(-ml:nx+ml,-ml:nz+ml,2)     !vx,vz�ֱ���x�����ٶȷ�����z�����ٶȷ���
  Real :: txx(-ml:nx+ml,-ml:nz+ml,2),tzz(-ml:nx+ml,-ml:nz+ml,2),&
          txz(-ml:nx+ml,-ml:nz+ml,2)                              !txx,tzz,txz�ֱ�������Ӧ������
  Real :: vxxi1(ml,-ml:nz+ml,2),vxxi2(ml,-ml:nz+ml,2),&	          !���� �߽� 
          vxxj1(-ml:nx+ml,ml,2),vxxj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽� 
  Real :: vxzi1(ml,-ml:nz+ml,2),vxzi2(ml,-ml:nz+ml,2),&	          !���� �߽� 
          vxzj1(-ml:nx+ml,ml,2),vxzj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽� 
  Real :: vzxi1(ml,-ml:nz+ml,2),vzxi2(ml,-ml:nz+ml,2),&	          !���� �߽� 
          vzxj1(-ml:nx+ml,ml,2),vzxj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽� 
  Real :: vzzi1(ml,-ml:nz+ml,2),vzzi2(ml,-ml:nz+ml,2),&	          !���� �߽� 
          vzzj1(-ml:nx+ml,ml,2),vzzj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽� 
  Real :: t1xi1(ml,-ml:nz+ml,2),t1xi2(ml,-ml:nz+ml,2),&           !���� �߽� 
          t1xj1(-ml:nx+ml,ml,2),t1xj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�      t1=txx
  Real :: t1zi1(ml,-ml:nz+ml,2),t1zi2(ml,-ml:nz+ml,2),&           !���� �߽�
          t1zj1(-ml:nx+ml,ml,2),t1zj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�
  Real :: t2xi1(ml,-ml:nz+ml,2),t2xi2(ml,-ml:nz+ml,2),&           !���� �߽�	    t2=tzz  
          t2xj1(-ml:nx+ml,ml,2),t2xj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�
  Real :: t2zi1(ml,-ml:nz+ml,2),t2zi2(ml,-ml:nz+ml,2),&           !���� �߽�
          t2zj1(-ml:nx+ml,ml,2),t2zj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�        
  Real :: t3xi1(ml,-ml:nz+ml,2),t3xi2(ml,-ml:nz+ml,2),&           !���� �߽�	    t3=txz
          t3xj1(-ml:nx+ml,ml,2),t3xj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�
  Real :: t3zi1(ml,-ml:nz+ml,2),t3zi2(ml,-ml:nz+ml,2),&           !���� �߽�
          t3zj1(-ml:nx+ml,ml,2),t3zj2(-ml:nx+ml,ml,2)             !�ϡ��� �߽�
  Real :: vxt(nx,nt),vzt(nz,nt)                                   !vxt,vzt�ֱ��ǵ����¼x������z����
  Real :: xx,zz
  Real :: vum,vdm,vlm,vrm
  Real :: dx,dz
  Real :: qx(1:ml),qz(1:ml)
  Real :: qxd(1:ml),qzd(1:ml)
  Real :: r1,r2
  Integer(Kind=2) :: head(120)
  Integer(Kind=2) :: irecl1,irecl2                                !д���һ�ʼ�¼�ĳ���
  Integer :: ii1,ii2,jj1,jj2                                      !��Դ����Χ
  Real :: ef1,ef2,ef3,ef4                                         !��ַ���ϵ��
  Integer :: nt2,it,iit
  Integer :: n_file,n_file2                                       !��Ҫ�������ļ�����(��С��999)
  Character(len=9) :: filename1_x,filename1_z
  Character(len=11) :: filename2_x,filename2_z
  Character(len=4) :: file_extension
  Character(len=80) :: Output_filename_x,Output_filename_z
  Character(len=16) :: vx_file,vz_file
  Character(len=16),Allocatable :: snapshot_x(:),snapshot_z(:)    !�������Ķ���ļ����ļ���
  Character(len=18),Allocatable :: seismogram_x(:),seismogram_z(:)
  Real :: time
  Real :: fx
  Real :: dxz
  Real :: fc0
  Real :: s1,s2
  Integer :: nx1,nz1
  Integer :: count
  Integer :: irec
  Integer :: ii
  Real :: a11,a12,a13,a14,a21,a22,a23,a24
  Real :: b11,b12,b13,b14,b21,b22,b23,b24
  Real :: d11,d12,d13,d14,d21,d22,d23,d24
  Real :: e11,e12,e13,e14,e21,e22,e23,e24
  Integer :: i,j,k
  Character(len=14) :: Outpath
  
  Outpath='Output_Result\'
  
  r1=delt_t/(delt_x*2.0)
  r2=delt_t/(delt_z*2.0)
  
  Open(110,file='����.dat')
  Open(13,file=Input_file_modelpar,status='old')
  Read(13,*)
  Do j=1,nz
    Do i=1,nx
      Read(13,*) xx,zz,c11(i,j),c13(i,j),c33(i,j),c44(i,j),density(i,j)
      Write(110,'(7E12.3/)') xx,zz,c11(i,j),c13(i,j),c33(i,j),c44(i,j),density(i,j)
    End Do
  End Do
  Close(13)
  Close(110)
  
  Do j=1,nz
    Do i=1,nx
      vp(i,j)=sqrt(c33(i,j)/density(i,j))
      vs(i,j)=sqrt(c44(i,j)/density(i,j))
    End Do
  End Do

  
  vum=0.0
  Do i=-ml,nx+ml
    Do j=-ml,0
      c11(i,j)=c11(i,1)
      c13(i,j)=c13(i,1)
      c33(i,j)=c33(i,1)
      c44(i,j)=c44(i,1)
      density(i,j)=density(i,1)
      vp(i,j)=sqrt(c33(i,j)/density(i,j))
      vs(i,j)=sqrt(c44(i,j)/density(i,j))
      vum=max(vum,vp(i,j))
    End Do
  End Do
  
  vdm=0.0
  Do i=-ml,nx+ml
    Do j=nz+1,nz+ml
      c11(i,j)=c11(i,nz)
      c13(i,j)=c13(i,nz)
      c33(i,j)=c33(i,nz)
      c44(i,j)=c44(i,nz)
      density(i,j)=density(i,nz)
      vp(i,j)=sqrt(c33(i,j)/density(i,j))
      vs(i,j)=sqrt(c44(i,j)/density(i,j))
    End Do
  End Do
  
  vlm=0.0
  Do j=-ml,nz+ml
    Do i=-ml,0
      c11(i,j)=c11(1,j)
      c13(i,j)=c13(1,j)
      c33(i,j)=c33(1,j)
      c44(i,j)=c44(1,j)
      density(i,j)=density(1,j)
      vp(i,j)=sqrt(c33(i,j)/density(i,j))
      vs(i,j)=sqrt(c44(i,j)/density(i,j))
      vlm=max(vlm,vp(i,j))
    End Do
  End Do
  
  vrm=0.0
  Do j=-ml,nz+ml
    Do i=nx+1,ml+nx
      c11(i,j)=c11(nx,j)
      c13(i,j)=c13(nx,j)
      c33(i,j)=c33(nx,j)
      c44(i,j)=c44(nx,j)
      density(i,j)=density(nx,j)
      vp(i,j)=sqrt(c33(i,j)/density(i,j))
      vs(i,j)=sqrt(c44(i,j)/density(i,j))
      vrm=max(vrm,vp(i,j))
    End Do
  End Do
  
  dx=3.0*log(1.0/reflect_coefficient)*vlm/(2.0*ml*delt_x)
  dz=3.0*log(1.0/reflect_coefficient)*vlm/(2.0*ml*delt_z)
  Do i=1,ml
    qx(i)=delt_t*dx*((ml-i)*delt_x/(ml*delt_x))**2
    qz(i)=delt_t*dz*((ml-i)*delt_z/(ml*delt_z))**2
    qxd(i)=1.0/(1.0+qx(i))
    qzd(i)=1.0/(1.0+qz(i))
  End Do
    
  vx=0.0;vz=0.0	  
  txx=0.0;tzz=0.0;txz=0.0
  vxxi1=0.0;vxxi2=0.0;vxxj1=0.0;vxxj2=0.0
  vxzi1=0.0;vxzi2=0.0;vxzj1=0.0;vxzj2=0.0
  vzxi1=0.0;vzxi2=0.0;vzxj1=0.0;vzxj2=0.0
  vzzi1=0.0;vzzi2=0.0;vzzj1=0.0;vzzj2=0.0
  t1xi1=0.0;t1xi2=0.0;t1xj1=0.0;t1xj2=0.0
  t1zi1=0.0;t1zi2=0.0;t1zj1=0.0;t1zj2=0.0
  t2xi1=0.0;t2xi2=0.0;t2xj1=0.0;t2xj2=0.0
  t2zi1=0.0;t2zi2=0.0;t2zj1=0.0;t2zj2=0.0
  t3xi1=0.0;t3xi2=0.0;t3xj1=0.0;t3xj2=0.0
  t3zi1=0.0;t3zi2=0.0;t3zj1=0.0;t3zj2=0.0

!----------------���ɲ��������ļ�����ʼ-------------------------
  n_file=int(nt/400)   !��������������ո����ļ���
  Allocate(snapshot_x(1:n_file),snapshot_z(1:n_file))
  filename1_x='snapshotx'
  filename1_z='snapshotz'
  file_extension='.sgy'
  Output_filename_x='snapshots_x.txt'
  Output_filename_z='snapshots_z.txt'
  
  Call Create_file(n_file,filename1_x,file_extension,snapshot_x,Output_filename_x)
  Call Create_file(n_file,filename1_z,file_extension,snapshot_z,Output_filename_z)
  
  n_file2=int(ig2/20.0+0.5)
  Allocate(seismogram_x(1:n_file2),seismogram_z(1:n_file2))
  filename2_x='seismogramx'
  filename2_z='seismogramz'
  file_extension='.dat'
  Output_filename_x='seismogram_x.txt'
  Output_filename_z='seismogram_z.txt'
  
  Call Create_file(n_file2,filename2_x,file_extension,seismogram_x(:),Output_filename_x)
  Call Create_file(n_file2,filename2_z,file_extension,seismogram_z(:),Output_filename_z)
!----------------���ɲ��������ļ�������-------------------------

  head(58)=nz+2*ml+1
  head(59)=2000
  irecl1=(nz+2*ml+1)*4+240
  
  Do i=1,n_file
    Open(i+100,file=Outpath//snapshot_x(i),form='binary',access='direct',status='replace',recl=irecl1)
    Open(i+200,file=Outpath//snapshot_z(i),form='binary',access='direct',status='replace',recl=irecl1)
  End Do
  
  Do i=1,n_file2
    Open(i+300,file=Outpath//seismogram_x(i),status='replace')
    Open(i+400,file=Outpath//seismogram_z(i),status='replace')
  End Do
  
  nt2=nt*2
  ii1=max(1,is-10)       
  ii2=min(nx,is+10)      
  jj1=max(1,js-10)       
  jj2=min(nz,js+10)      
  ef1=1225.0/1024.0      
  ef2=245.0/3072.0       
  ef3=441.0/46080.0      
  ef4=5.0/7168.0
  fx=0.0
  
  Do it=1,nt2
    If(mod(it,2).ne.0) Then   !����������������в���
      iit=(it+1)/2.0
      time=(iit-1)*delt_t          
      Call source_force(fre_wavelet,delay_source_t0,time,fc0)	!������Դ���� 
      Do j=1,nz
        Do i=1,nx
          
          If(iit.le.300) Then
            If(i.ge.ii1.and.i.le.ii2.and.j.ge.jj1.and.j.le.jj2) Then	  
              dxz=((i-is)**2+(j-js)**2)*0.1               
              fx=fc0*exp(-dxz)
            End If
          End If
          
	        a11=txx(i,j,2)-txx(i-1,j-1,2)
	        a12=txx(i+1,j+1,2)-txx(i-2,j-2,2)
	        a13=txx(i+2,j+2,2)-txx(i-3,j-3,2)
	        a14=txx(i+3,j+3,2)-txx(i-4,j-4,2)
          a21=txx(i,j-1,2)-txx(i-1,j,2)
          a22=txx(i+1,j-2,2)-txx(i-2,j+1,2)
          a23=txx(i+2,j-3,2)-txx(i-3,j+2,2)
          a24=txx(i+3,j-4,2)-txx(i-4,j+3,2)
          b11=txz(i,j,2)-txz(i-1,j-1,2)
          b12=txz(i+1,j+1,2)-txz(i-2,j-2,2)
          b13=txz(i+2,j+2,2)-txz(i-3,j-3,2)
          b14=txz(i+3,j+3,2)-txz(i-4,j-4,2)
          b21=txz(i,j-1,2)-txz(i-1,j,2)
          b22=txz(i+1,j-2,2)-txz(i-2,j+1,2)
          b23=txz(i+2,j-3,2)-txz(i-3,j+2,2)
          b24=txz(i+3,j-4,2)-txz(i-4,j+3,2)
	        d11=tzz(i,j,2)-tzz(i-1,j-1,2)
	        d12=tzz(i+1,j+1,2)-tzz(i-2,j-2,2)
	        d13=tzz(i+2,j+2,2)-tzz(i-3,j-3,2)
	        d14=tzz(i+3,j+3,2)-tzz(i-4,j-4,2)
          d21=tzz(i,j-1,2)-tzz(i-1,j,2)
          d22=tzz(i+1,j-2,2)-tzz(i-2,j+1,2)
          d23=tzz(i+2,j-3,2)-tzz(i-3,j+2,2)
          d24=tzz(i+3,j-4,2)-tzz(i-4,j+3,2)
	        vx(i,j,2)=vx(i,j,1)+1/density(i,j)*r1*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))+&
                              1/density(i,j)*r2*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))+fx
	        vz(i,j,2)=vz(i,j,1)+1/density(i,j)*r2*((ef1*d11-ef2*d12+ef3*d13-ef4*d14)-(ef1*d21-ef2*d22+ef3*d23-ef4*d24))+&
                              1/density(i,j)*r1*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)+(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
        End Do
      End Do
      
      Do j=1,nz          !i=1--->-(ml-1), i=ml--->0	 ��߽�
        Do i=4,ml
	        a11=txx(-ml+i,j,2)-txx(-ml+i-1,j-1,2)
	        a12=txx(-ml+i+1,j+1,2)-txx(-ml+i-2,j-2,2)
	        a13=txx(-ml+i+2,j+2,2)-txx(-ml+i-3,j-3,2)
	        a14=txx(-ml+i+3,j+3,2)-txx(-ml+i-4,j-4,2)
          a21=txx(-ml+i,j-1,2)-txx(-ml+i-1,j,2)
          a22=txx(-ml+i+1,j-2,2)-txx(-ml+i-2,j+1,2)
          a23=txx(-ml+i+2,j-3,2)-txx(-ml+i-3,j+2,2)
          a24=txx(-ml+i+3,j-4,2)-txx(-ml+i-4,j+3,2)
          b11=txz(-ml+i,j,2)-txz(-ml+i-1,j-1,2)
          b12=txz(-ml+i+1,j+1,2)-txz(-ml+i-2,j-2,2)
          b13=txz(-ml+i+2,j+2,2)-txz(-ml+i-3,j-3,2)
          b14=txz(-ml+i+3,j+3,2)-txz(-ml+i-4,j-4,2)
          b21=txz(-ml+i,j-1,2)-txz(-ml+i-1,j,2)
          b22=txz(-ml+i+1,j-2,2)-txz(-ml+i-2,j+1,2)
          b23=txz(-ml+i+2,j-3,2)-txz(-ml+i-3,j+2,2)
          b24=txz(-ml+i+3,j-4,2)-txz(-ml+i-4,j+3,2)
          d11=tzz(-ml+i,j,2)-tzz(-ml+i-1,j-1,2)
	        d12=tzz(-ml+i+1,j+1,2)-tzz(-ml+i-2,j-2,2)
	        d13=tzz(-ml+i+2,j+2,2)-tzz(-ml+i-3,j-3,2)
	        d14=tzz(-ml+i+3,j+3,2)-tzz(-ml+i-4,j-4,2)
          d21=tzz(-ml+i,j-1,2)-tzz(-ml+i-1,j,2)
          d22=tzz(-ml+i+1,j-2,2)-tzz(-ml+i-2,j+1,2)
          d23=tzz(-ml+i+2,j-3,2)-tzz(-ml+i-3,j+2,2)
          d24=tzz(-ml+i+3,j-4,2)-tzz(-ml+i-4,j+3,2)
          
	        s1=1/density(-ml+i,j)*r1*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
	        s2=(1.0-0.5*qx(i))*vxxi1(i,j,1)			
	        vxxi1(i,j,2)=(s1+s2)*qxd(i)
	        s1=1/density(-ml+i,j)*r2*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=0.0
	        vxzi1(i,j,2)=vxzi1(i,j,1)+(s1+s2)
	        vx(-ml+i,j,2)=vxxi1(i,j,2)+vxzi1(i,j,2) !����vx
          
          s1=1/density(-ml+i,j)*r1*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)+(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
          s2=(1.0-0.5*qx(i))*vzxi1(i,j,1)
          vzxi1(i,j,2)=(s1+s2)*qxd(i)
	        s1=1/density(-ml+i,j)*r2*((ef1*d11-ef2*d12+ef3*d13-ef4*d14)-(ef1*d21-ef2*d22+ef3*d23-ef4*d24))
	        s2=0.0
	        vzzi1(i,j,2)=vzzi1(i,j,1)+(s1+s2)
	        vz(-ml+i,j,2)=vzxi1(i,j,2)+vzzi1(i,j,2) !����vz     
        End Do
      End Do
      
      Do j=1,nz
        Do i=1,ml
          vxxi1(i,j,1)=vxxi1(i,j,2)
          vxzi1(i,j,1)=vxzi1(i,j,2)
          vzxi1(i,j,1)=vzxi1(i,j,2)
          vzzi1(i,j,1)=vzzi1(i,j,2)
        End Do
      End Do

      nx1=nx+ml+1
      Do j=1,nz      !i=1--->-(ml-1), i=ml--->nx+1	  �ұ߽�
        Do i=ml,5,-1
          a11=txx(nx1-i,j,2)-txx(nx1-i-1,j-1,2)
	        a12=txx(nx1-i+1,j+1,2)-txx(nx1-i-2,j-2,2)
	        a13=txx(nx1-i+2,j+2,2)-txx(nx1-i-3,j-3,2)
	        a14=txx(nx1-i+3,j+3,2)-txx(nx1-i-4,j-4,2)
          a21=txx(nx1-i,j-1,2)-txx(nx1-i-1,j,2)
          a22=txx(nx1-i+1,j-2,2)-txx(nx1-i-2,j+1,2)
          a23=txx(nx1-i+2,j-3,2)-txx(nx1-i-3,j+2,2)
          a24=txx(nx1-i+3,j-4,2)-txx(nx1-i-4,j+3,2)
          b11=txz(nx1-i,j,2)-txz(nx1-i-1,j-1,2)
          b12=txz(nx1-i+1,j+1,2)-txz(nx1-i-2,j-2,2)
          b13=txz(nx1-i+2,j+2,2)-txz(nx1-i-3,j-3,2)
          b14=txz(nx1-i+3,j+3,2)-txz(nx1-i-4,j-4,2)
          b21=txz(nx1-i,j-1,2)-txz(nx1-i-1,j,2)
          b22=txz(nx1-i+1,j-2,2)-txz(nx1-i-2,j+1,2)
          b23=txz(nx1-i+2,j-3,2)-txz(nx1-i-3,j+2,2)
          b24=txz(nx1-i+3,j-4,2)-txz(nx1-i-4,j+3,2)
          d11=tzz(nx1-i,j,2)-tzz(nx1-i-1,j-1,2)
	        d12=tzz(nx1-i+1,j+1,2)-tzz(nx1-i-2,j-2,2)
	        d13=tzz(nx1-i+2,j+2,2)-tzz(nx1-i-3,j-3,2)
	        d14=tzz(nx1-i+3,j+3,2)-tzz(nx1-i-4,j-4,2)
          d21=tzz(nx1-i,j-1,2)-tzz(nx1-i-1,j,2)
          d22=tzz(nx1-i+1,j-2,2)-tzz(nx1-i-2,j+1,2)
          d23=tzz(nx1-i+2,j-3,2)-tzz(nx1-i-3,j+2,2)
          d24=tzz(nx1-i+3,j-4,2)-tzz(nx1-i-4,j+3,2)
          
	        s1=1/density(nx1-i,j)*r1*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
	        s2=(1.0-0.5*qx(i))*vxxi2(i,j,1)			
	        vxxi2(i,j,2)=(s1+s2)*qxd(i)
	        s1=1/density(nx1-i,j)*r2*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=0.0
	        vxzi2(i,j,2)=vxzi2(i,j,1)+(s1+s2)
	        vx(nx1-i,j,2)=vxxi2(i,j,2)+vxzi2(i,j,2) !����vx
          
          s1=1/density(nx1-i,j)*r1*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)+(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
          s2=(1.0-0.5*qx(i))*vzxi2(i,j,1)
	        vzxi2(i,j,2)=(s1+s2)*qxd(i)
	        s1=1/density(nx1-i,j)*r2*((ef1*d11-ef2*d12+ef3*d13-ef4*d14)-(ef1*d21-ef2*d22+ef3*d23-ef4*d24))
	        s2=0.0
	        vzzi2(i,j,2)=vzzi2(i,j,1)+(s1+s2)
	        vz(nx1-i,j,2)=vzxi2(i,j,2)+vzzi2(i,j,2) !����vz       
        End Do
      End Do
      
      Do j=1,nz
        Do i=1,ml
	        vxxi2(i,j,1)=vxxi2(i,j,2)
	        vxzi2(i,j,1)=vxzi2(i,j,2)
	        vzxi2(i,j,1)=vzxi2(i,j,2)	    
	        vzzi2(i,j,1)=vzzi2(i,j,2)
        End Do
      End Do
      
      Do j=4,ml                   ! j=ml--->0	 �ϱ߽�
        Do i=-ml+4,nx+ml-4
	        k=ml
	        if(i.le.0) k=ml+i       !��������1��3��7��9  
	        if(i.gt.nx) k=nx+ml-i+1
	        a11=txx(i,-ml+j,2)-txx(i-1,-ml+j-1,2)
	        a12=txx(i+1,-ml+j+1,2)-txx(i-2,-ml+j-2,2)
	        a13=txx(i+2,-ml+j+2,2)-txx(i-3,-ml+j-3,2)
	        a14=txx(i+3,-ml+j+3,2)-txx(i-4,-ml+j-4,2)
          a21=txx(i,-ml+j-1,2)-txx(i-1,-ml+j,2)
          a22=txx(i+1,-ml+j-2,2)-txx(i-2,-ml+j+1,2)
          a23=txx(i+2,-ml+j-3,2)-txx(i-3,-ml+j+2,2)
          a24=txx(i+3,-ml+j-4,2)-txx(i-4,-ml+j+3,2)
          b11=txz(i,-ml+j,2)-txz(i-1,-ml+j-1,2)
          b12=txz(i+1,-ml+j+1,2)-txz(i-2,-ml+j-2,2)
          b13=txz(i+2,-ml+j+2,2)-txz(i-3,-ml+j-3,2)
          b14=txz(i+3,-ml+j+3,2)-txz(i-4,-ml+j-4,2)
          b21=txz(i,-ml+j-1,2)-txz(i-1,-ml+j,2)
          b22=txz(i+1,-ml+j-2,2)-txz(i-2,-ml+j+1,2)
          b23=txz(i+2,-ml+j-3,2)-txz(i-3,-ml+j+2,2)
          b24=txz(i+3,-ml+j-4,2)-txz(i-4,-ml+j+3,2)
          d11=tzz(i,-ml+j,2)-tzz(i-1,-ml+j-1,2)
	        d12=tzz(i+1,-ml+j+1,2)-tzz(i-2,-ml+j-2,2)
	        d13=tzz(i+2,-ml+j+2,2)-tzz(i-3,-ml+j-3,2)
	        d14=tzz(i+3,-ml+j+3,2)-tzz(i-4,-ml+j-4,2)
          d21=tzz(i,-ml+j-1,2)-tzz(i-1,-ml+j,2)
          d22=tzz(i+1,-ml+j-2,2)-tzz(i-2,-ml+j+1,2)
          d23=tzz(i+2,-ml+j-3,2)-tzz(i-3,-ml+j+2,2)
          d24=tzz(i+3,-ml+j-4,2)-tzz(i-4,-ml+j+3,2)
          
	        s1=1/density(i,-ml+j)*r1*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
	        s2=(1.0-0.5*qx(k))*vxxj1(i,j,1)			
	        vxxj1(i,j,2)=(s1+s2)*qxd(k)
	        s1=1/density(i,-ml+j)*r2*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
          s2=(1.0-0.5*qx(j))*vxzj1(i,j,1)
	        vxzj1(i,j,2)=(s1+s2)*qxd(j)
	        vx(i,-ml+j,2)=vxxj1(i,j,2)+vxzj1(i,j,2)
            
	        s1=1/density(i,-ml+j)*r1*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)+(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=(1.0-0.5*qx(k))*vzxj1(i,j,1)
	        vzxj1(i,j,2)=(s1+s2)*qxd(k)
	        s1=1/density(i,-ml+j)*r2*((ef1*d11-ef2*d12+ef3*d13-ef4*d14)-(ef1*d21-ef2*d22+ef3*d23-ef4*d24))
          s2=(1.0-0.5*qx(j))*vzzj1(i,j,1)
	        vzzj1(i,j,2)=(s1+s2)*qxd(j)
	        vz(i,-ml+j,2)=vzxj1(i,j,2)+vzzj1(i,j,2)
        End Do
      End Do
      
      Do j=1,ml
        Do i=-ml,nx+ml
	        vxxj1(i,j,1)=vxxj1(i,j,2)   	    
	        vxzj1(i,j,1)=vxzj1(i,j,2)
	        vzxj1(i,j,1)=vzxj1(i,j,2)   	    
	        vzzj1(i,j,1)=vzzj1(i,j,2)
        End Do
      End Do
      
      nz1=nz+ml+1
      Do j=ml,5,-1                !i=1--->-(ml-1), i=ml--->nx+1	  �±߽�
        Do i=-ml+4,nx+ml-4
	        k=ml
	        if(i.le.0) k=ml+i         !��������1��3��7��9  
	        if(i.gt.nx) k=nx+ml-i+1
	        a11=txx(i,nz1-j,2)-txx(i-1,nz1-j-1,2)
	        a12=txx(i+1,nz1-j+1,2)-txx(i-2,nz1-j-2,2)
	        a13=txx(i+2,nz1-j+2,2)-txx(i-3,nz1-j-3,2)
	        a14=txx(i+3,nz1-j+3,2)-txx(i-4,nz1-j-4,2)
          a21=txx(i,nz1-j-1,2)-txx(i-1,nz1-j,2)
          a22=txx(i+1,nz1-j-2,2)-txx(i-2,nz1-j+1,2)
          a23=txx(i+2,nz1-j-3,2)-txx(i-3,nz1-j+2,2)
          a24=txx(i+3,nz1-j-4,2)-txx(i-4,nz1-j+3,2)
          b11=txz(i,nz1-j,2)-txz(i-1,nz1-j-1,2)
          b12=txz(i+1,nz1-j+1,2)-txz(i-2,nz1-j-2,2)
          b13=txz(i+2,nz1-j+2,2)-txz(i-3,nz1-j-3,2)
          b14=txz(i+3,nz1-j+3,2)-txz(i-4,nz1-j-4,2)
          b21=txz(i,nz1-j-1,2)-txz(i-1,nz1-j,2)
          b22=txz(i+1,nz1-j-2,2)-txz(i-2,nz1-j+1,2)
          b23=txz(i+2,nz1-j-3,2)-txz(i-3,nz1-j+2,2)
          b24=txz(i+3,nz1-j-4,2)-txz(i-4,nz1-j+3,2)
          d11=tzz(i,nz1-j,2)-tzz(i-1,nz1-j-1,2)
	        d12=tzz(i+1,nz1-j+1,2)-tzz(i-2,nz1-j-2,2)
	        d13=tzz(i+2,nz1-j+2,2)-tzz(i-3,nz1-j-3,2)
	        d14=tzz(i+3,nz1-j+3,2)-tzz(i-4,nz1-j-4,2)
          d21=tzz(i,nz1-j-1,2)-tzz(i-1,nz1-j,2)
          d22=tzz(i+1,nz1-j-2,2)-tzz(i-2,nz1-j+1,2)
          d23=tzz(i+2,nz1-j-3,2)-tzz(i-3,nz1-j+2,2)
          d24=tzz(i+3,nz1-j-4,2)-tzz(i-4,nz1-j+3,2)
          
	        s1=1/density(i,nz1-j)*r1*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
	        s2=(1.0-0.5*qx(k))*vxxj2(i,j,1)
	        vxxj2(i,j,2)=(s1+s2)*qxd(k)
	        s1=1/density(i,nz1-j)*r2*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=(1.0-0.5*qx(j))*vxzj2(i,j,1)
	        vxzj2(i,j,2)=(s1+s2)*qxd(j)
	        vx(i,nz1-j,2)=vxxj2(i,j,2)+vxzj2(i,j,2)
            
	        s1=1/density(i,nz1-j)*r1*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)+(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=(1.0-0.5*qx(k))*vzxj2(i,j,1)
	        vzxj2(i,j,2)=(s1+s2)*qxd(k)
	        s1=1/density(i,nz1-j)*r2*((ef1*d11-ef2*d12+ef3*d13-ef4*d14)-(ef1*d21-ef2*d22+ef3*d23-ef4*d24))
	        s2=(1.0-0.5*qx(j))*vzzj2(i,j,1)
	        vzzj2(i,j,2)=(s1+s2)*qxd(j)
	        vz(i,nz1-j,2)=vzxj2(i,j,2)+vzzj2(i,j,2)
        End Do
      End Do
      
      Do j=1,ml
        Do i=-ml,nx+ml
	        vxxj2(i,j,1)=vxxj2(i,j,2)    	    
	        vxzj2(i,j,1)=vxzj2(i,j,2)
	        vzxj2(i,j,1)=vzxj2(i,j,2)  
	        vzzj2(i,j,1)=vzzj2(i,j,2)
        End Do
      End Do

      Do j=-ml,nz+ml     
        Do i=-ml,nx+ml   
          vx(i,j,1)=vx(i,j,2)   !��ǰһʱ�̼���Ĳ���ֵvx(i,j,2)��ֵ��vx(i,j,1)
          vz(i,j,1)=vz(i,j,2)  
        End Do
      End Do
    
      Do i=1,nx
        vxt(i,iit)=vx(i,ige,2)    !��������Ϊ0��ǰһʱ�̵Ĳ���ֵ��ֵ��������Ϊ0�ļ첨��
        vzt(i,iit)=vz(i,ige,2)
      End Do
      
      Do i=1,n_file2              !����ϳɵ���ͼ
        j=6+(i-1)*20
        Write(i+300,*) time,vxt(j,iit)
        Write(i+400,*) time,vzt(j,iit)
      End Do
              
      If(mod(iit,400).eq.0) Then
        k=0
        Do i=-ml,nx+ml     
          k=k+1
          count=int(iit/400)
          Write(count+100,rec=k) head,(vx(i,j,2),j=-ml,nz+ml) !����������� 
          Write(count+200,rec=k) head,(vz(i,j,2),j=-ml,nz+ml) 
        End Do
      End If
      
      If(mod(iit,10).eq.0) Write(*,*) iit,vx(is,js,2)
      
    Else
      iit=it/2.0
      
      Do j=1,nz
        Do i=1,nx
          a11=vx(i+1,j+1,2)-vx(i,j,2)
          a12=vx(i+2,j+2,2)-vx(i-1,j-1,2)
          a13=vx(i+3,j+3,2)-vx(i-2,j-2,2)
          a14=vx(i+4,j+4,2)-vx(i-3,j-3,2)
          a21=vx(i+1,j,2)-vx(i,j+1,2)
          a22=vx(i+2,j-1,2)-vx(i-1,j+2,2)
          a23=vx(i+3,j-2,2)-vx(i-2,j+3,2)
          a24=vx(i+4,j-3,2)-vx(i-3,j+4,2)
          b11=vz(i+1,j+1,2)-vz(i,j,2)
          b12=vz(i+2,j+2,2)-vz(i-1,j-1,2)
          b13=vz(i+3,j+3,2)-vz(i-2,j-2,2)
          b14=vz(i+4,j+4,2)-vz(i-3,j-3,2)
          b21=vz(i+1,j,2)-vz(i,j+1,2)
          b22=vz(i+2,j-1,2)-vz(i-1,j+2,2)
          b23=vz(i+3,j-2,2)-vz(i-2,j+3,2)
          b24=vz(i+4,j-3,2)-vz(i-3,j+4,2)
          txx(i,j,2)=txx(i,j,1)+r1*c11(i,j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))+&
                                r2*c13(i,j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))    
          tzz(i,j,2)=tzz(i,j,1)+r1*c13(i,j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))+&
                                r2*c33(i,j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))    
          txz(i,j,2)=txz(i,j,1)+r1*c44(i,j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)+(ef1*b21-ef2*b22+ef3*b23-ef4*b24))+&
                                r2*c44(i,j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)-(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
        End Do
      End Do
      
      Do j=1,nz                   !i=1--->-(ml-1), i=ml--->0	  ��߽�
        Do i=4,ml
	        a11=vx(-ml+i+1,j+1,2)-vx(-ml+i,j,2)
          a12=vx(-ml+i+2,j+2,2)-vx(-ml+i-1,j-1,2)
          a13=vx(-ml+i+3,j+3,2)-vx(-ml+i-2,j-2,2)
          a14=vx(-ml+i+4,j+4,2)-vx(-ml+i-3,j-3,2)
          a21=vx(-ml+i+1,j,2)-vx(-ml+i,j+1,2)
          a22=vx(-ml+i+2,j-1,2)-vx(-ml+i-1,j+2,2)
          a23=vx(-ml+i+3,j-2,2)-vx(-ml+i-2,j+3,2)
          a24=vx(-ml+i+4,j-3,2)-vx(-ml+i-3,j+4,2)
          b11=vz(-ml+i+1,j+1,2)-vz(-ml+i,j,2)
          b12=vz(-ml+i+2,j+2,2)-vz(-ml+i-1,j-1,2)
          b13=vz(-ml+i+3,j+3,2)-vz(-ml+i-2,j-2,2)
          b14=vz(-ml+i+4,j+4,2)-vz(-ml+i-3,j-3,2)
          b21=vz(-ml+i+1,j,2)-vz(-ml+i,j+1,2)
          b22=vz(-ml+i+2,j-1,2)-vz(-ml+i-1,j+2,2)
          b23=vz(-ml+i+3,j-2,2)-vz(-ml+i-2,j+3,2)
          b24=vz(-ml+i+4,j-3,2)-vz(-ml+i-3,j+4,2)
          
	        s1=r1*c11(-ml+i,j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
	        s2=(1.0-0.5*qx(i))*t1xi1(i,j,1)
	        t1xi1(i,j,2)=(s1+s2)*qxd(i)
	        s1=r2*c13(-ml+i,j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=0.0 
	        t1zi1(i,j,2)=t1zi1(i,j,1)+s1+s2
	        txx(-ml+i,j,2)=t1xi1(i,j,2)+t1zi1(i,j,2)
            
	        s1=r1*c13(-ml+i,j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
          s2=(1.0-0.5*qx(i))*t2xi1(i,j,1)
	        t2xi1(i,j,2)=(s1+s2)*qxd(i)
	        s1=r2*c33(-ml+i,j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=0.0
	        t2zi1(i,j,2)=t2zi1(i,j,1)+s1+s2
	        tzz(-ml+i,j,2)=t2xi1(i,j,2)+t2zi1(i,j,2)
          
	        s1=r1*c44(-ml+i,j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)+(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=(1.0-0.5*qx(i))*t3xi1(i,j,1)
	        t3xi1(i,j,2)=(s1+s2)*qxd(i)
	        s1=r2*c44(-ml+i,j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)-(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
	        s2=0.0
	        t3zi1(i,j,2)=t3zi1(i,j,1)+s1+s2
	        txz(-ml+i,j,2)=t3xi1(i,j,2)+t3zi1(i,j,2)
        End Do
      End Do
      
      Do j=1,nz
        Do i=1,ml
	        t1xi1(i,j,1)=t1xi1(i,j,2)
	        t1zi1(i,j,1)=t1zi1(i,j,2)
	        t2xi1(i,j,1)=t2xi1(i,j,2)
	        t2zi1(i,j,1)=t2zi1(i,j,2)
	        t3xi1(i,j,1)=t3xi1(i,j,2)
	        t3zi1(i,j,1)=t3zi1(i,j,2)
        End Do
      End Do
      
      nx1=nx+ml+1
      Do j=1,nz                !i=1--->-(ml-1), i=ml--->nx+1 �ұ߽�
        Do i=ml,5,-1
          a11=vx(nx1-i+1,j+1,2)-vx(nx1-i,j,2)
          a12=vx(nx1-i+2,j+2,2)-vx(nx1-i-1,j-1,2)
          a13=vx(nx1-i+3,j+3,2)-vx(nx1-i-2,j-2,2)
          a14=vx(nx1-i+4,j+4,2)-vx(nx1-i-3,j-3,2)
          a21=vx(nx1-i+1,j,2)-vx(nx1-i,j+1,2)
          a22=vx(nx1-i+2,j-1,2)-vx(nx1-i-1,j+2,2)
          a23=vx(nx1-i+3,j-2,2)-vx(nx1-i-2,j+3,2)
          a24=vx(nx1-i+4,j-3,2)-vx(nx1-i-3,j+4,2)
          b11=vz(nx1-i+1,j+1,2)-vz(nx1-i,j,2)
          b12=vz(nx1-i+2,j+2,2)-vz(nx1-i-1,j-1,2)
          b13=vz(nx1-i+3,j+3,2)-vz(nx1-i-2,j-2,2)
          b14=vz(nx1-i+4,j+4,2)-vz(nx1-i-3,j-3,2)
          b21=vz(nx1-i+1,j,2)-vz(nx1-i,j+1,2)
          b22=vz(nx1-i+2,j-1,2)-vz(nx1-i-1,j+2,2)
          b23=vz(nx1-i+3,j-2,2)-vz(nx1-i-2,j+3,2)
          b24=vz(nx1-i+4,j-3,2)-vz(nx1-i-3,j+4,2)
          
	        s1=r1*c11(nx1-i,j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
	        s2=(1.0-0.5*qx(i))*t1xi2(i,j,1)
	        t1xi2(i,j,2)=(s1+s2)*qxd(i)
	        s1=r2*c13(nx1-i,j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=0.0 
	        t1zi2(i,j,2)=t1zi2(i,j,1)+s1+s2
	        txx(nx1-i,j,2)=t1xi2(i,j,2)+t1zi2(i,j,2)
            
	        s1=r1*c13(nx1-i,j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
          s2=(1.0-0.5*qx(i))*t2xi2(i,j,1)
	        t2xi2(i,j,2)=(s1+s2)*qxd(i)
	        s1=r2*c33(nx1-i,j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=0.0
	        t2zi2(i,j,2)=t2zi2(i,j,1)+s1+s2
	        tzz(nx1-i,j,2)=t2xi2(i,j,2)+t2zi2(i,j,2)
          
	        s1=r1*c44(nx1-i,j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)+(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=(1.0-0.5*qx(i))*t3xi2(i,j,1)
	        t3xi2(i,j,2)=(s1+s2)*qxd(i)
	        s1=r2*c44(nx1-i,j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)-(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
	        s2=0.0
	        t3zi2(i,j,2)=t3zi2(i,j,1)+s1+s2
	        txz(nx1-i,j,2)=t3xi2(i,j,2)+t3zi2(i,j,2)
        End Do
      End Do
      
      Do j=1,nz
        Do i=1,ml
	        t1xi2(i,j,1)=t1xi2(i,j,2)
	        t1zi2(i,j,1)=t1zi2(i,j,2)
	        t2xi2(i,j,1)=t2xi2(i,j,2)
	        t2zi2(i,j,1)=t2zi2(i,j,2)
	        t3xi2(i,j,1)=t3xi2(i,j,2)
	        t3zi2(i,j,1)=t3zi2(i,j,2)
        End Do
      End Do
      
      Do j=4,ml                   ! j=ml--->0	  �ϱ߽�
        Do i=-ml+4,nx+ml-4
	        k=ml
	        if(i.le.0) k=ml+i
	        if(i.gt.nx) k=nx+ml-i+1
	        a11=vx(i+1,-ml+j+1,2)-vx(i,-ml+j,2)
          a12=vx(i+2,-ml+j+2,2)-vx(i-1,-ml+j-1,2)
          a13=vx(i+3,-ml+j+3,2)-vx(i-2,-ml+j-2,2)
          a14=vx(i+4,-ml+j+4,2)-vx(i-3,-ml+j-3,2)
          a21=vx(i+1,-ml+j,2)-vx(i,-ml+j+1,2)
          a22=vx(i+2,-ml+j-1,2)-vx(i-1,-ml+j+2,2)
          a23=vx(i+3,-ml+j-2,2)-vx(i-2,-ml+j+3,2)
          a24=vx(i+4,-ml+j-3,2)-vx(i-3,-ml+j+4,2)
          b11=vz(i+1,-ml+j+1,2)-vz(i,-ml+j,2)
          b12=vz(i+2,-ml+j+2,2)-vz(i-1,-ml+j-1,2)
          b13=vz(i+3,-ml+j+3,2)-vz(i-2,-ml+j-2,2)
          b14=vz(i+4,-ml+j+4,2)-vz(i-3,-ml+j-3,2)
          b21=vz(i+1,-ml+j,2)-vz(i,-ml+j+1,2)
          b22=vz(i+2,-ml+j-1,2)-vz(i-1,-ml+j+2,2)
          b23=vz(i+3,-ml+j-2,2)-vz(i-2,-ml+j+3,2)
          b24=vz(i+4,-ml+j-3,2)-vz(i-3,-ml+j+4,2)
          
	        s1=r1*c11(i,-ml+j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
	        s2=(1.0-0.5*qx(k))*t1xj1(i,j,1)
	        t1xj1(i,j,2)=(s1+s2)*qxd(k)
	        s1=r2*c13(i,-ml+j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
          s2=(1.0-0.5*qx(j))*t1zj1(i,j,1) 
	        t1zj1(i,j,2)=(s1+s2)*qxd(j)
	        txx(i,-ml+j,2)=t1xj1(i,j,2)+t1zj1(i,j,2)
            
	        s1=r1*c13(i,-ml+j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
          s2=(1.0-0.5*qx(k))*t2xj1(i,j,1)
	        t2xj1(i,j,2)=(s1+s2)*qxd(k)
	        s1=r2*c33(i,-ml+j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
          s2=(1.0-0.5*qx(j))*t2zj1(i,j,1)
	        t2zj1(i,j,2)=(s1+s2)*qxd(j)
	        tzz(i,-ml+j,2)=t2xj1(i,j,2)+t2zj1(i,j,2)
            
	        s1=r1*c44(i,-ml+j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)+(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=(1.0-0.5*qx(k))*t3xj1(i,j,1)
	        t3xj1(i,j,2)=(s1+s2)*qxd(k)
	        s1=r2*c44(i,-ml+j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)-(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
          s2=(1.0-0.5*qx(j))*t3zj1(i,j,1)
	        t3zj1(i,j,2)=(s1+s2)*qxd(j)
	        txz(i,-ml+j,2)=t3xj1(i,j,2)+t3zj1(i,j,2)
        End Do
      End Do
      
      Do j=1,ml
        Do i=-ml,nx+ml
	        t1xj1(i,j,1)=t1xj1(i,j,2)
	        t1zj1(i,j,1)=t1zj1(i,j,2)
	        t2xj1(i,j,1)=t2xj1(i,j,2)
	        t2zj1(i,j,1)=t2zj1(i,j,2)
	        t3xj1(i,j,1)=t3xj1(i,j,2)
	        t3zj1(i,j,1)=t3zj1(i,j,2)
        End Do
      End Do
      
      nz1=nz+ml+1
      Do j=ml,5,-1                ! j=ml--->nz+1 �±߽�
        Do i=-ml+4,nx+ml-4
	        k=ml
	        if(i.le.0) k=ml+i
	        if(i.gt.nx) k=nx+ml-i+1
	        a11=vx(i+1,nz1-j+1,2)-vx(i,nz1-j,2)
          a12=vx(i+2,nz1-j+2,2)-vx(i-1,nz1-j-1,2)
          a13=vx(i+3,nz1-j+3,2)-vx(i-2,nz1-j-2,2)
          a14=vx(i+4,nz1-j+4,2)-vx(i-3,nz1-j-3,2)
          a21=vx(i+1,nz1-j,2)-vx(i,nz1-j+1,2)
          a22=vx(i+2,nz1-j-1,2)-vx(i-1,nz1-j+2,2)
          a23=vx(i+3,nz1-j-2,2)-vx(i-2,nz1-j+3,2)
          a24=vx(i+4,nz1-j-3,2)-vx(i-3,nz1-j+4,2)
          b11=vz(i+1,nz1-j+1,2)-vz(i,nz1-j,2)
          b12=vz(i+2,nz1-j+2,2)-vz(i-1,nz1-j-1,2)
          b13=vz(i+3,nz1-j+3,2)-vz(i-2,nz1-j-2,2)
          b14=vz(i+4,nz1-j+4,2)-vz(i-3,nz1-j-3,2)
          b21=vz(i+1,nz1-j,2)-vz(i,nz1-j+1,2)
          b22=vz(i+2,nz1-j-1,2)-vz(i-1,nz1-j+2,2)
          b23=vz(i+3,nz1-j-2,2)-vz(i-2,nz1-j+3,2)
          b24=vz(i+4,nz1-j-3,2)-vz(i-3,nz1-j+4,2)
          
	        s1=r1*c11(i,nz1-j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
	        s2=(1.0-0.5*qx(k))*t1xj2(i,j,1)
	        t1xj2(i,j,2)=(s1+s2)*qxd(k)
	        s1=r2*c13(i,nz1-j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=(1.0-0.5*qx(j))*t1zj2(i,j,2) 
	        t1zj2(i,j,2)=(s1+s2)*qxd(j)
	        txx(i,nz1-j,2)=t1xj2(i,j,2)+t1zj2(i,j,2)
           
	        s1=r1*c13(i,nz1-j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)+(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
          s2=(1.0-0.5*qx(k))*t2xj2(i,j,1)
	        t2xj2(i,j,2)=(s1+s2)*qxd(k)
	        s1=r2*c33(i,nz1-j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)-(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=(1.0-0.5*qx(j))*t2zj2(i,j,1)
	        t2zj2(i,j,2)=(s1+s2)*qxd(j)
	        tzz(i,nz1-j,2)=t2xj2(i,j,2)+t2zj2(i,j,2)
           
	        s1=r1*c44(i,nz1-j)*((ef1*b11-ef2*b12+ef3*b13-ef4*b14)+(ef1*b21-ef2*b22+ef3*b23-ef4*b24))
	        s2=(1.0-0.5*qx(k))*t3xj2(i,j,1)
	        t3xj2(i,j,2)=(s1+s2)*qxd(k)
	        s1=r2*c44(i,nz1-j)*((ef1*a11-ef2*a12+ef3*a13-ef4*a14)-(ef1*a21-ef2*a22+ef3*a23-ef4*a24))
	        s2=(1.0-0.5*qx(j))*t3zj2(i,j,1)
	        t3zj2(i,j,2)=(s1+s2)*qxd(j)
	        txz(i,nz1-j,2)=t3xj2(i,j,2)+t3zj2(i,j,2)
        End Do
      End Do
      
      Do j=1,ml
        Do i=-ml,nx+ml
	        t1xj2(i,j,1)=t1xj2(i,j,2)
	        t1zj2(i,j,1)=t1zj2(i,j,2)
	        t2xj2(i,j,1)=t2xj2(i,j,2)
	        t2zj2(i,j,1)=t2zj2(i,j,2)
	        t3xj2(i,j,1)=t3xj2(i,j,2)
	        t3zj2(i,j,1)=t3zj2(i,j,2)
        End Do
      End Do

      Do j=-ml,nz+ml   
        Do i=-ml,nx+ml 
          txx(i,j,1)=txx(i,j,2)
          tzz(i,j,1)=tzz(i,j,2)
          txz(i,j,1)=txz(i,j,2)
        End Do
      End Do 
      
    End If
  End Do
  
  Do i=1,n_file
    Close(i+100)
    Close(i+200)
  End Do
  
  Do i=1,n_file2
    Close(i+300)
    Close(i+400)
  End Do
  
  irecl2=nt*4+240
  head(58)=nt
  head(59)=delt_t*1000000
  
  Open(16,file=Outpath//'synthetic_seismic_record_x.sgy',form='binary',access='direct',status='replace',recl=irecl2)
  Open(17,file=Outpath//'synthetic_seismic_record_z.sgy',form='binary',access='direct',status='replace',recl=irecl2)     
  Do i=ig1,ig2
    ii=i-ig1+1
    Write(16,rec=ii) head,(vxt(i,j),j=1,nt)
    Write(17,rec=ii) head,(vzt(i,j),j=1,nt)
  End Do
  Close(16)
  Close(17)
  
  Deallocate(snapshot_x,snapshot_z)
  Deallocate(seismogram_x,seismogram_z)
  
  vx_file='seismogram_x.txt'
  vz_file='seismogram_z.txt'
  
  Call grapher_seismograms(n_file2,nt,vx_file,vz_file)
    
End Subroutine Wave_Field_Modeling