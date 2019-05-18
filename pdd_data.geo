//Maio, 2019 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd-puro (sem o gerador)

u = 1e-3;           // unidade = mm
mm = 1e-3;
cm = 1e-2;          // unidade
deg2rad = Pi/180;   // graus para radianos

//Point(0) = {0,0,0,1.0}; //origem/

pp = "Input/Constructive parameters/";

DefineConstant[
  NbrPolesInModel = { 6, Choices{ 2="2",6="6"}, Name "Input/20Number of poles in FE model", Highlight "Blue"},
  InitialRotorAngle_deg = { 0, Name "Input/20Initial rotor angle [deg]", Highlight "AliceBlue"},
  InitialRotor2Angle_deg = { 0, Name "Input/20Initial rotor 2 angle [deg]", Highlight "AliceBlue"},
  Flag_OpenStator = {0, Choices{0,1}, Name "Input/39Open slots in stator"}
];

NbrStatorPolesInModel = NbrPolesInModel*9;
If(NbrStatorPolesInModel>50)
  NbrStatorPolesInModel=50;
EndIf

NbrPolesTot = 6;                                                // Numero total de polos na máquina
NbrPolePairs = NbrPolesTot/2 ;

NbrStatorPolesTot = 50;                                                // Numero total de polos na máquina
NbrStatorPolePairs = NbrStatorPolesTot/2 ;

SymmetryFactor = NbrPolesTot/NbrPolesInModel;
Flag_Symmetry = (SymmetryFactor==1)?0:1;

// Rotor
NbrSectTot = 6;                                                         // number of rotor teeth
NbrSect = (NbrSectTot*NbrPolesInModel)/NbrPolesTot;                     // number of rotor teeth in FE model
Qr = NbrSectTot;
N_rs = NbrSect;

//Stator
NbrSectStatorTot = 39;                                                  // number of stator teeth
NbrSectStator = (NbrSectStatorTot*NbrPolesInModel/NbrPolesTot);         // number of stator teeth in FE model
Qs = NbrSectStatorTot;
N_ss = NbrSectStator;

NbrSectStatorMagTot = 50;                                                  //numero de imas colados no estator
NbrSectStatorMag = (NbrSectStatorMagTot*NbrStatorPolesInModel/NbrStatorPolesTot);      //number of stator teeth in FE model
Qs_mag = NbrSectStatorMagTot;
N_ss_mag = NbrSectStatorMag;

//--------------------------------------------------------------------------------

InitialRotorAngle = InitialRotorAngle_deg*deg2rad ; // initial rotor angle, 0 if aligned
InitialRotor2Angle = InitialRotor2Angle_deg*deg2rad ; // initial rotor angle, 0 if aligned

RotorAngle_R = InitialRotorAngle + Pi/NbrSectTot-Pi/2; // initial rotor angle (radians)
RotorAngle_S = RotorAngle_R;

Rotor2Angle_R = InitialRotor2Angle + Pi/NbrSectTot-Pi/2; // initial rotor2 angle (radians)
Rotor2Angle_S = Rotor2Angle_R;

DefineConstant
[
  AG = {u*0.30, Name StrCat[pp, "Airgap width [m]"], Closed 1,Highlight "Gold"},
  R_sin = {0.160, Name StrCat[pp, "Raio Interno do Estator [m]"],Highlight "SteelBlue"},
  R_sout = {0.210, Name StrCat[pp,  "Raio Externo do Estator [m]"],Highlight "SteelBlue"},
  R_rin = {0.0495, Name StrCat[pp, "Raio Interno do Rotor [m]"],Highlight "SkyBlue"},
  R_rout = {0.133, Name StrCat[pp, "Raio Externo do Rotor [m]"],Highlight "SkyBlue"},
  h_m = {0.008, Name StrCat[pp, "Altura do Imã [m]"],Highlight "ForestGreen"},
  R_s_mag_in = {u*157.6, Name StrCat[pp, "Raio interno imãs estator [m]"],Highlight "Orchid"}
];

//-------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------//

sigma_fe = 0. ; // laminated steel
DefineConstant
[
  mur_fe = {1000, Name StrCat[pp, "Relative permeability for linear case"]},   //default = 1000
  b_remanent = {1.2, Name StrCat[pp, "Remanent induction [T]"] }
];

rpm_nominal = 1200;
Inominal = 10.9 ; // Nominal current
Tnominal = 2.5 ; // Nominal torque

//-------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------//

// ----------------------------------------------------
// Numbers for physical regions in .geo and .pro files
// ----------------------------------------------------
// Rotor
ROTOR_FE     = 500 ;
ROTOR_AIRGAP = 2000 ;
ROTOR_MAGNET = 60000 ; // Index for first Magnet (1/8 model->1; full model->8)

ROTOR_BND_MOVING_BAND = 4000 ; // Index for first line (1/8 model->1; full model->8)
ROTOR_BND_A0 = 5000 ;
ROTOR_BND_A1 = 6000 ;

ROTOR2_FE           = 7000;
ROTOR2_AIRGAPTOP    = 8000;
ROTOR2_AIRGAPBOTTOM = 9000;
ROTOR2_AIR          = 10000;
ROTOR2_TOP_BND_MOVING_BAND    = 11000;
ROTOR2_BOTTOM_BND_MOVING_BAND = 12000;
ROTOR2_BND_A0 = 13000;
ROTOR2_BND_A1 = 14000;

SURF_INT     = 15000 ;

// Stator
STATOR_FE     = 16000 ;
STATOR_AIR    = 17000 ;
STATOR_MAGNET = 40000 ;
STATOR_AIRGAP = 19000 ;
STATOR_SLOTOPENING = 20000 ; // Slot opening

STATOR_BND_MOVING_BAND = 21000 ;// Index for first line (1/8 model->1; full model->8)
STATOR_BND_A0          = 22000 ;
STATOR_BND_A1          = 23000 ;

STATOR_IND = 24000;
STATOR_IND_AP = STATOR_IND + 1 ; STATOR_IND_CM = STATOR_IND + 2 ;STATOR_IND_BP = STATOR_IND + 3 ;
STATOR_IND_AM = STATOR_IND + 4 ; STATOR_IND_CP = STATOR_IND + 5 ;STATOR_IND_BM = STATOR_IND + 6 ;

STATOR_IND = 25000 ; //Index for first Ind (1/8 model->3; full model->24)
STATOR_IND_AP = STATOR_IND + 1 ; STATOR_IND_BM = STATOR_IND + 2 ;STATOR_IND_CP = STATOR_IND + 3 ;
STATOR_IND_AM = STATOR_IND + 4 ; STATOR_IND_BP = STATOR_IND + 5 ;STATOR_IND_CM = STATOR_IND + 6 ;

SURF_EXT = 26000 ; // outer boundary


MOVING_BAND = 27000 ;

NICEPOS = 28000 ;
