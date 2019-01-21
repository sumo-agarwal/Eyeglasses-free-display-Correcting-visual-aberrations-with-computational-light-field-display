function [m1,x1]=build_calcy(pix_no_x,lens_x,pix_size,lens_size,pix_lens_d,do,dis_res,temp1,temp2, bound)
%m,n == x,y
 m1=2;
[x1,x2,aperture_x1,aperture_x2]=onepix_mullens(pix_no_x-(dis_res/2+1),pix_no_x-(dis_res/2),lens_x,lens_x,pix_size,lens_size,pix_lens_d,do,temp1,temp2);


if aperture_x2<-bound && aperture_x1>-bound && aperture_x1<bound
    x2=x1-(x1-x2)/(aperture_x1-aperture_x2)*(aperture_x1+bound);
end
if aperture_x2>-bound && aperture_x2<bound && aperture_x1>bound
   x1=(x1-x2)/(aperture_x1-aperture_x2)*(bound-aperture_x2)+x2;
end
if aperture_x2<-bound && aperture_x1>bound
    a=x1;
    b=x2;
    x1=x1-(a-b)/(aperture_x1-aperture_x2)*(x1-bound);
    x2=x2+(a-b)/(aperture_x1-aperture_x2)*(-bound-x2);
end
if aperture_x2>bound && aperture_x1>bound
   m1=0;
end
if aperture_x2<-bound && aperture_x1<-bound
   m1=0;
end
end