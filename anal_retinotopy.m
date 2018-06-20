clear group
global group anal

for i_sub = 1:prm.nsubj
    %% retinotopy - compute the analysis and data bricks for each block
    for i_block = anal.compute_blocks %blocks go 1234 PolarNPolarPEccenNEccenP
        srate = data(i_sub).PC(i_block).boxy_hdr.sample_rate;

        %% Slow data
        fprintf('Computing Slow Retinotopy analysis. ')
        tic
        %initialize
        group(i_block).slow_power = zeros(1, vox(i_sub).nvox);
        group(i_block).slow_phase = group(i_block).slow_power;
        %subtact mean
        %get correct frequency
        [tempB,tempP,freqs] = kyle_fft(data(i_sub).PC(i_block).HbOvox(:,1)',srate,20);
        i_freq = find(freqs>=anal.freq_spin,1);
        %Find the power and phase of the 48 second spin modulation of the flicker
        %power
        %get the power and phase of the AC data at the spin freq
        for i_chan = 1:vox(i_sub).nvox

            if vox(i_sub).empty(i_chan) == 0
                [B2,P2,freqs] = kyle_fft(data(i_sub).PC(i_block).HbOvox(:,i_chan)',srate,20);
                group(i_block).slow_power(i_chan) = B2(i_freq);
                group(i_block).slow_phase(i_chan) = P2(i_freq);
            else
                group(i_block).slow_power(i_chan) = 0;
                group(i_block).slow_phase(i_chan) = 0;
            end
        end
        toc

        %% Fast Data
        % %find power of the flicker for each channel over time with wavelets
        %Find the power and phase of the 48 second spin modulation of the flicker
        %power
         fprintf('Computing Fast Retinotopy analysis. ')
        tic
        %initializae
        group(i_block).fast_power = group(i_block).slow_power;
        group(i_block).fast_phase = group(i_block).slow_power;
        for i_chan = 1:vox(i_sub).nvox
            if vox(i_sub).empty(i_chan) == 0
                %first get time series of flash power
                [B] = BOSC_tf(data(i_sub).PC(i_block).phvox(:,i_chan),anal.freq_flash,srate,anal.wave_num);
                %Then power and phase of this flash at the spin frequency
                [B3,P3] = kyle_fft(log10(B),srate,20);
                group(i_block).fast_power(i_chan) = B3(i_freq);
                group(i_block).fast_phase(i_chan) = P3(i_freq);
            else
                group(i_block).fast_power(i_chan) = 0;
                group(i_block).fast_phase(i_chan) = 0;
            end
        end
        toc

        %% Create subject data briks
         fprintf('Creating data briks. ')
        tic
        for i_vox = 1:vox(i_sub).nvox
            group(i_block).slowpower(vox(i_sub).x(i_vox),vox(i_sub).y(i_vox),vox(i_sub).z(i_vox),i_sub) = group(i_block).slow_power(i_vox);
            group(i_block).slowphase(vox(i_sub).x(i_vox),vox(i_sub).y(i_vox),vox(i_sub).z(i_vox),i_sub) = group(i_block).slow_phase(i_vox);
            group(i_block).fastpower(vox(i_sub).x(i_vox),vox(i_sub).y(i_vox),vox(i_sub).z(i_vox),i_sub) = group(i_block).fast_power(i_vox);
            group(i_block).fastphase(vox(i_sub).x(i_vox),vox(i_sub).y(i_vox),vox(i_sub).z(i_vox),i_sub) = group(i_block).fast_phase(i_vox);
        end
        toc

    end
end

%was in here at once - don't need anymore (didn't work for mulitple subjects, less size to not use, filled in later once img_banan)
%         group(i_block).slowpower = zeros(maxprm.kre2,maxprm.kre2,maxprm.kre2,prm.nsubj);
%         group(i_block).slowphase = group.slowpower;
%         group(i_block).fastpower = group.slowpower;
%         group(i_block).fastphase = group.slowpower;
