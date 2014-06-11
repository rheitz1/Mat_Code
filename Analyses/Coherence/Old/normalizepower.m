%normalize power

for sess = 1:size(uncorrectedpow_ss2,1)
    normby_ss2 = max(uncorrectedpow_ss2(sess,:));
    normby_ss4 = max(uncorrectedpow_ss4(sess,:));
    normby_ss8 = max(uncorrectedpow_ss8(sess,:));
    
    uncorrectedpow_ss2_norm(sess,1:size(uncorrectedpow_ss2,2)) = uncorrectedpow_ss2(sess,:)./normby_ss2;
    uncorrectedpow_ss4_norm(sess,1:size(uncorrectedpow_ss2,2)) = uncorrectedpow_ss4(sess,:)./normby_ss4;
    uncorrectedpow_ss8_norm(sess,1:size(uncorrectedpow_ss2,2)) = uncorrectedpow_ss8(sess,:)./normby_ss8;
    
    
    
    normby_ss2 = max(correctedpow_ss2(sess,:));
    normby_ss4 = max(correctedpow_ss4(sess,:));
    normby_ss8 = max(correctedpow_ss8(sess,:));
    
    correctedpow_ss2_norm(sess,1:size(correctedpow_ss2,2)) = correctedpow_ss2(sess,:)./normby_ss2;
    correctedpow_ss4_norm(sess,1:size(correctedpow_ss2,2)) = correctedpow_ss4(sess,:)./normby_ss4;
    correctedpow_ss8_norm(sess,1:size(correctedpow_ss2,2)) = correctedpow_ss8(sess,:)./normby_ss8;
end