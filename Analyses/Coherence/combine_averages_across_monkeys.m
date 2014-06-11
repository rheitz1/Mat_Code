keep tout f TDT_all alldif alldif_bc alldif s2dif s4dif s8dif fsdif sldif errdif alldif_bc s2dif_bc s4dif_bc s8dif_bc fsdif_bc sldif_bc errdif_bc

renvar TDT_all Q_TDT_all
renvar alldif Q_alldif
renvar alldif_bc Q_alldif_bc
renvar errdif Q_errdif
renvar errdif_bc Q_errdif_bc
renvar fsdif Q_fsdif
renvar fsdif_bc Q_fsdif_bc
renvar s2dif Q_s2dif
renvar s2dif_bc Q_s2dif_bc
renvar s4dif Q_s4dif
renvar s4dif_bc Q_s4dif_bc
renvar s8dif Q_s8dif
renvar s8dif_bc Q_s8dif_bc
renvar sldif Q_sldif
renvar sldif_bc Q_sldif_bc

% renvar TDT_all S_TDT_all
% renvar alldif S_alldif
% renvar alldif_bc S_alldif_bc
% renvar errdif S_errdif
% renvar errdif_bc S_errdif_bc
% renvar fsdif S_fsdif
% renvar fsdif_bc S_fsdif_bc
% renvar s2dif S_s2dif
% renvar s2dif_bc S_s2dif_bc
% renvar s4dif S_s4dif
% renvar s4dif_bc S_s4dif_bc
% renvar s8dif S_s8dif
% renvar s8dif_bc S_s8dif_bc
% renvar sldif S_sldif
% renvar sldif_bc S_sldif_bc

ws send [1] Q_TDT_all
ws send [1] Q_alldif
ws send [1] Q_alldif_bc
ws send [1] Q_errdif
ws send [1] Q_errdif_bc
ws send [1] Q_fsdif
ws send [1] Q_fsdif_bc
ws send [1] Q_s2dif
ws send [1] Q_s2dif_bc
ws send [1] Q_s4dif
ws send [1] Q_s4dif_bc
ws send [1] Q_s8dif
ws send [1] Q_s8dif_bc
ws send [1] Q_sldif
ws send [1] Q_sldif_bc


alldif_bc = [Q_alldif_bc S_alldif_bc];
alldif = [Q_alldif S_alldif];

errdif_bc = [Q_errdif_bc S_errdif_bc];
errdif = [Q_errdif S_errdif];

fsdif_bc = [Q_fsdif_bc S_fsdif_bc];
fsdif = [Q_fsdif S_fsdif];

s2dif_bc = [Q_s2dif_bc S_s2dif_bc];
s2dif = [Q_s2dif S_s2dif];

s4dif_bc = [Q_s4dif_bc S_s4dif_bc];
s4dif = [Q_s4dif S_s4dif];

s8dif_bc = [Q_s8dif_bc S_s8dif_bc];
s8dif = [Q_s8dif S_s8dif];

sldif_bc = [Q_sldif_bc S_sldif_bc];
sldif = [Q_sldif S_sldif];