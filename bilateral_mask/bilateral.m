function Ifilt = bilateral(I, averageFilterRadius, sigmaSpatial, sigmaIntensity)

    % pad image to reduce boundary artifacts
    I = padarray(I,[averageFilterRadius averageFilterRadius],'symmetric');

    % initialize filtered image as 0
    Ifilt = zeros(size(I));
    
    % smoothing kernel - you can use that as a look-up table for the
    % spatial kernel if you like
    spatialKernel = fspecial('gaussian', [2*averageFilterRadius+1 2*averageFilterRadius+1], sigmaSpatial);
        
    for ky= 1+averageFilterRadius:size(I,1)-averageFilterRadius
        for kx= 1+averageFilterRadius:size(I,2)-averageFilterRadius
            
            % extract current pixel
            currentPixel = I(ky,kx,:);
                            
            % accumulated normalization factor
            normalizationFactor = zeros([1 1 size(I,3)]);
            
            % go over a window of size 2*averageFilterRadius+1 around the
            % current pixel, compute weights, sum the weighted intensity
            for c = 1:size(I,3)
                local_window = I(ky-averageFilterRadius: ky+averageFilterRadius,kx-averageFilterRadius: kx+averageFilterRadius, c);
                intensityKernel = exp(-(local_window - currentPixel(:,:,c)).^2/2/sigmaIntensity^2);
                W = spatialKernel.*intensityKernel;
                Ifilt(ky,kx,c) = sum(sum(W.*local_window));
                normalizationFactor(1,1,c) = sum(sum(W));
            end
            % normalize pixel value
            Ifilt(ky,kx,:) = Ifilt(ky,kx,:) ./ normalizationFactor;

        end
    end
    
    % crop black boundary
    Ifilt = Ifilt(averageFilterRadius+1:end-averageFilterRadius, averageFilterRadius+1:end-averageFilterRadius,:);
end

