clear all;
photo = imread('photo.jpg');
imgsize = size(photo,1);

level = 150; % Level of pixel intensity added to original photo

photop = photo;
photon = photo;

blocksize = 2; % n*n minimum block size
blocknum = imgsize/blocksize; % the addition or subtraction pixel intensity within a block is consitent
for i = 0 : blocknum-1
    for j = 0 : blocknum-1
        get_rand = rand;
        p = level * (get_rand > 0.5) - level * (get_rand <= 0.5);
        n = -p;
        for channel = 1 : 3 % may leverage brightness for better result
            tmp_min = 255; % prevent intensity overflow
            for ii = 1:blocksize
                for jj = 1:blocksize
                    a1 = photo( (i*blocksize + ii), (j*blocksize + jj), channel );
                    b1 = 255 - photo( (i*blocksize + ii), (j*blocksize + jj), channel );
                    if min(a1,b1) < tmp_min
                        tmp_min = min(a1,b1);
                    end
                end
            end
        
            true_level = double(min(tmp_min, level)); % conver to double to support subtraction
            
            if rand>0.5 
                p = true_level;
            else
                p = -true_level;
            end
            n = -p;
        
            for ii = 1:blocksize
                for jj = 1:blocksize
                    photop( (i*blocksize + ii), (j*blocksize + jj), channel ) = ...
                        photo( (i*blocksize + ii), (j*blocksize + jj), channel ) + p;
                    photon( (i*blocksize + ii), (j*blocksize + jj), channel ) = ...
                        photo( (i*blocksize + ii), (j*blocksize + jj), channel ) + n;
                end
            end
        end
    end
end



figure;imshow(photop);
figure;imshow(photon);
