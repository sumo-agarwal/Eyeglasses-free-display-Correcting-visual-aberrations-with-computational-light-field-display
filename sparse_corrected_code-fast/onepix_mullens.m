function [x,y,apertures_x,apertures_y]= onepix_mullens(pix_x1,pix_y1,lens_x,lens_y,pix_size,lens_size,pix_lens_d,do,temp1,temp2)
 mx=((lens_x+0.5)*lens_size-(pix_x1)*pix_size)/pix_lens_d;
 my=((lens_y+0.5)*lens_size-(pix_y1)*pix_size)/pix_lens_d;
 apertures_x=(pix_x1)*pix_size + mx*do;
 apertures_y=(pix_y1)*pix_size + my*do;
 imag_m_x= temp1*(pix_x1); 
 imag_m_y=temp1*(pix_y1);
 temp_x= temp2*(apertures_x+imag_m_x);
 temp_y= temp2*(apertures_y+imag_m_y);
 x=apertures_x-temp_x;
 y=apertures_y-temp_y;
end
