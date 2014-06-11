% % bar chart of G2 values on session fits

cd /volumes/Dump/Analyses/SAT/Models/NoMed

load Q_session_fits_NoMed

allLL_Q1 = structfun(@sum,LL);

keep allLL_Q1

load S_session_fits_NoMed

allLL_S1 = structfun(@sum,LL);

keep allLL_Q* allLL_S*

cd /volumes/Dump/Analyses/SAT/Models/Med

load Q_session_fits_Med

allLL_Q2 = structfun(@sum,LL);

keep allLL_Q* allLL_S*

load S_session_fits_Med

allLL_S2 = structfun(@sum,LL);

keep allLL_S* allLL_Q*

allLL_S = allLL_S1 + allLL_S2;
allLL_Q = allLL_Q1 + allLL_Q2;

G2_Q = -2 .* (allLL_Q - allLL_Q(1));
G2_S = -2 .* (allLL_S - allLL_S(1));

[a b] = sort(G2_Q);

figure
bar([G2_Q(b) G2_S(b)],'barwidth',1)
set(gca,'xtick',1:16)
set(gca,'xticklabel',b)
set(gca,'tickdir','out')
box off

title('G2 across sessions')



clear all


cd /volumes/Dump/Analyses/SAT/Models

load Q_population_fits_MedNoMed

allLL_Q = structfun(@sum,LL);

keep allLL_Q

load S_population_fits_MedNoMed

allLL_S = structfun(@sum,LL);

keep allLL*


G2_Q = -2 .* (allLL_Q - allLL_Q(1));
G2_S = -2 .* (allLL_S - allLL_S(1));

[a b] = sort(G2_Q);

figure
bar([G2_Q(b) G2_S(b)],'barwidth',1)
set(gca,'xtick',1:16)
set(gca,'xticklabel',b)
set(gca,'tickdir','out')
box off

title('G2 across population')