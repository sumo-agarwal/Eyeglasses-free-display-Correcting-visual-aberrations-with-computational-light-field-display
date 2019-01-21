function [m1,m2]=build_calc_space(pix_no_x,lens_x,pix_size,lens_size,pix_lens_d,do,dow,cam_pix_size,dis_res,temp1,temp2,bound)
%m,n == x,y
 
[x1,x2,aperture_x1,aperture_x2]=onepix_mullens(pix_no_x-(dis_res/2+2/3),pix_no_x-(dis_res/2+1/3),lens_x,lens_x,pix_size,lens_size,pix_lens_d,do,temp1,temp2);

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
end