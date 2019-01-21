% The aperture_size is the parameter set in 2 files build_calc and camera
% file.
cam_res=750; % CAMERA resolution decided by the user of the code. Basically higher resolution will provide better images but code running time increases by a lot.
 % The increased resolution will increase the ability of the code to reolve
 % even smaller areas in the image.
dis_res=750;        % DISPLAY RESOLUTION
pix_size=0.078;     % PIXEL SIZE
do=250;             % Distance from camera to screen (mm)
f=50;           
Fstop = 5;% Focal length of camera lens (mm)
camera_focus= 450;  % focus distance at which the camera is set
sens_d = camera_focus*f/(camera_focus-f); % Decided distance between the retina and the pupil as decided by the camera_focus
lens_size=0.234;    % Squared Microlens size (edge of square)
pix_lens_d=3.39;       % Gap between microlens and pixel
img2=im2double(imread('33_g.png'));  % Image input
img=img2(:,:,2);
aperture_size=f/Fstop;
bound=aperture_size/2;
img1=(reshape(img,dis_res*dis_res,1));
dividend=zeros(cam_res*cam_res,1);
imag_v= f*do/(do-f);
temp1=f*pix_size/(do-f);
temp2=sens_d/imag_v;
temp3=pix_size/lens_size;
var11=(imag_v-sens_d)/imag_v;
max_flag=0;
space_allocator=0;

for pix_x=1:1:dis_res
    a1=floor((pix_x-(dis_res/2))*temp3);
  for lens_x=a1-2:1:a1+2
     [m1,x1]=build_calcy(pix_x,lens_x,pix_size,lens_size,pix_lens_d,do,dis_res,temp1,temp2,bound);
  if(m1~=0)
     if(x1>max_flag)
      max_flag=x1;
     end
   end
  end
end
dow=-max_flag;
cam_pix_size=2*max_flag/cam_res;

for pix_x=1:1:dis_res
 a1=floor((pix_x-(dis_res/2))*temp3);
  for lens_x=a1-2:1:a1+2
    [x1,x2]=build_calc_space(pix_x,lens_x,pix_size,lens_size,pix_lens_d,do,dow,cam_pix_size,dis_res,temp1,temp2,bound);
     if(x1~=0)
     space_allocator=space_allocator+(x1-x2+1);  
     end
  end
 end

space_allocator=space_allocator^2;
sparse_col=zeros(space_allocator,1);
sparse_row=zeros(space_allocator,1);
sparse_val=zeros(space_allocator,1);
pix_y_keeper=zeros(750,5,2);




for pix_y=1:1:dis_res
  b1=floor((pix_y-(dis_res/2))*temp3); 
for lens_y=b1-2:1:b1+2
[y1,y2,aperture_y1,aperture_y2]=onepix_mullens(pix_y-(dis_res/2+2/3),pix_y-(dis_res/2+1/3),lens_y,lens_y,pix_size,lens_size,pix_lens_d,do,temp1,temp2);
if aperture_y2>=-bound && aperture_y2<=bound && aperture_y1>=-bound && aperture_y1<=bound
   n1=floor((y1-dow)/cam_pix_size)+1;
   n2=floor((y2-dow)/cam_pix_size)+1;
    if floor((y1-dow)/cam_pix_size)-(y1-dow)/cam_pix_size==0
         n1=floor((y1-dow)/cam_pix_size);
    end

elseif aperture_y2<=-bound && aperture_y1>=-bound && aperture_y1<=bound
    y2=y1-(y1-y2)/(aperture_y1-aperture_y2)*(aperture_y1+bound);
    n1=floor((y1-dow)/cam_pix_size)+1;
    n2=floor((y2-dow)/cam_pix_size)+1;
    if floor((y1-dow)/cam_pix_size)-(y1-dow)/cam_pix_size==0
         n1=floor((y1-dow)/cam_pix_size);
    end

elseif aperture_y2>=-bound && aperture_y2<=bound && aperture_y1>=bound
   y1=(y1-y2)/(aperture_y1-aperture_y2)*(bound-aperture_y2)+y2;
    n1=floor((y1-dow)/cam_pix_size)+1;
    n2=floor((y2-dow)/cam_pix_size)+1;
   if floor((y1-dow)/cam_pix_size)-(y1-dow)/cam_pix_size==0
         n1=floor((y1-dow)/cam_pix_size);
    end

elseif aperture_y2<=-bound && aperture_y1>=bound
    a=y1;
    b=y2;
    y1=y1-(a-b)/(aperture_y1-aperture_y2)*(y1-bound);
    y2=y2+(a-b)/(aperture_y1-aperture_y2)*((-bound)-y2);
    n1=floor((y1-dow)/cam_pix_size)+1;
    n2=floor((y2-dow)/cam_pix_size)+1;
    if floor((y1-dow)/cam_pix_size)-(y1-dow)/cam_pix_size==0
         n1=floor((y1-dow)/cam_pix_size);
    end

else
   n1=0;n2=0;
end
  pix_y_keeper(pix_y,lens_y-b1+3,1)=n1;
  pix_y_keeper(pix_y,lens_y-b1+3,2)=n2;
end
end
index=1;
for pix_x=1:1:dis_res
    r=dis_res*(pix_x-1);
  a1=floor((pix_x-(dis_res/2))*temp3);
 for lens_x=a1-2:1:a1+2
  [x1,x2,aperture_x1,aperture_x2]=onepix_mullens(pix_x-(dis_res/2+2/3),pix_x-(dis_res/2+1/3),lens_x,lens_x,pix_size,lens_size,pix_lens_d,do,temp1,temp2);
 % here x3 ---x1 , x4---x2
 
 if aperture_x2>=-bound && aperture_x2<=bound && aperture_x1>=-bound && aperture_x1<=bound
   m1=floor((x1-dow)/cam_pix_size)+1;
    m2=floor((x2-dow)/cam_pix_size)+1;
    if floor((x1-dow)/cam_pix_size)-(x1-dow)/cam_pix_size==0
         m1=floor((x1-dow)/cam_pix_size);
    end

elseif aperture_x2<=-bound && aperture_x1>=-bound && aperture_x1<=bound
    x2=x1-(x1-x2)/(aperture_x1-aperture_x2)*(aperture_x1+bound);
    m1=floor((x1-dow)/cam_pix_size)+1;
    m2=floor((x2-dow)/cam_pix_size)+1;
    if floor((x1-dow)/cam_pix_size)-(x1-dow)/cam_pix_size==0
         m1=floor((x1-dow)/cam_pix_size);
    end

elseif aperture_x2>=-bound && aperture_x2<=bound && aperture_x1>=bound
   x1=(x1-x2)/(aperture_x1-aperture_x2)*(bound-aperture_x2)+x2;
    m1=floor((x1-dow)/cam_pix_size)+1;
    m2=floor((x2-dow)/cam_pix_size)+1;
    if floor((x1-dow)/cam_pix_size)-(x1-dow)/cam_pix_size==0
         m1=floor((x1-dow)/cam_pix_size);
    end
elseif aperture_x2<=-bound && aperture_x1>=bound
    a=x1;
    b=x2;
    x1=x1-(a-b)/(aperture_x1-aperture_x2)*(x1-bound);
    x2=x2+(a-b)/(aperture_x1-aperture_x2)*(-bound-x2);
    m1=floor((x1-dow)/cam_pix_size)+1;
    m2=floor((x2-dow)/cam_pix_size)+1;
    if floor((x1-dow)/cam_pix_size)-(x1-dow)/cam_pix_size==0
         m1=floor((x1-dow)/cam_pix_size);
    end
else
         m1=0;m2=0;
end
       
  for pix_y=1:1:dis_res
      t=r+pix_y;
    for i=1:1:5
        n1=pix_y_keeper(pix_y,i,1);
        n2=pix_y_keeper(pix_y,i,2);
      if (m1~=0 && n1~=0)
     for(v=(cam_res*(m2-1)):cam_res:(cam_res*(m1-1)))
          %v=cam_res*(a-1);
         for(b=n2:1:n1)
              s=(v+b);
              sparse_col(index,1)=t;
              sparse_row(index,1)=s;
              sparse_val(index,1)=1;
              dividend(s,1)=1+dividend(s,1);
              index=index+1;
         end
     end
      end
    end
  end
 end
end

index=space_allocator;
for i=1:1:index
 %if(dividend(sparse_row(i,1),1)~=0)
  sparse_val(i,1)=sparse_val(i,1)/dividend(sparse_row(i,1),1);
 %end
end
psf_mat=sparse(sparse_row(1:index),sparse_col(1:index),sparse_val(1:index),...
cam_res^2,dis_res^2);

img_res=imresize(img,cam_res/dis_res);
img_res1=reshape(img_res,cam_res*cam_res,1);
B = speye(dis_res*dis_res)*0.07; % Matrix padders so that the singular matrix can be ignored by making it non-singular in A*X=B
F = speye(dis_res*dis_res,1)*0.07; % Matrix padders so that the singular matrix can be ignored by making it non-singular in A*X=B
psf_mat1=[psf_mat;B];
d=[img_res1;F];
r=psf_mat1';
m=r*psf_mat1;
bc=r*d;
x=pcg(m,bc,1e-6,1000000);
stim= psf_mat*x;
temp=zeros(dis_res,dis_res,3);
stimulate=zeros(cam_res,cam_res,3);
flag=reshape(x,dis_res,dis_res);
temp(:,:,2)=imrotate(flag,180);
stimulate(:,:,2)=reshape(stim,cam_res,cam_res);
imwrite(stimulate,'stimulated-33_g-750-pcg-750green.png','png');
imwrite(temp,'output1-33_g-750-pcg-750green.png','png');