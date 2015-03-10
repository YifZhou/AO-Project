LyotRadius = 0.8;
%% mask1
maskpara = linspace(0.5, 2.0, 100);
for i=1:100
    fn = sprintf('Lyot-%.2f-%s-%1.3f', LyotRadius, 'mask1', maskpara(i));
    HR8799(LyotRadius, 'mask1', maskpara(i), fn);
end

%% mask2
maskpara = linspace(0.3, 0.95, 100);

for i=1:100
    fn = sprintf('Lyot-%.2f-%s-%1.3f', LyotRadius, 'mask2', maskpara(i));
    HR8799(LyotRadius, 'mask2', maskpara(i), fn);
end

%% mask3
maskpara = logspace(-3,0,100);
for i=1:100
    fn = sprintf('Lyot-%.2f-%s-%1.2e', LyotRadius, 'mask3', maskpara(i));
    HR8799(LyotRadius, 'mask3', maskpara(i), fn);
end