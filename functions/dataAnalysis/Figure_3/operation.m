function [out1,out2,out3,out4]=operation(inpt1,inpt2,cnd)


if cnd==1
    out1=inpt1;
    out2=inpt2;
    out3=0;
    out4=0;

elseif cnd == 2
    
    out1=log10(inpt1);
    out2=log10(inpt2);
    out3=1;
    out4=0;

elseif cnd ==3
    
    out1=bootstrp(10000,@mean,inpt1);
    out2=bootstrp(10000,@mean,inpt2);
    out3=0;
    out4=1;
    

elseif cnd == 4

    out1_temp=log10(inpt1);
    out2_temp=log10(inpt2);

    out1=bootstrp(10000,@mean,out1_temp);
    out2=bootstrp(10000,@mean,out2_temp);
    
    out3=1;
    out4=1;
end
