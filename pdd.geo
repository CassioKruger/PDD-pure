//Maio, 2019 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd-puro (sem o gerador)

Include "pdd_data.geo" ;

Solver.AutoShowLastStep = 1;
Mesh.Algorithm = 1;
Geometry.CopyMeshingMethod = 1;

nicepos_rotor[] = {};
nicepos_rotor2[] = {};
nicepos_stator_mag[] = {};

// some characteristic lengths...
//----------------------------------------
pslo = mm * 3*2/2/1.5; // slot opening
psl  = mm * 2.2; // upper part slot
pout = mm * 12; // outer radius
pMB  = mm * 1 * 2/2; // MB
p  = mm*12*0.05*1.3;    //rotor

Include "pdd_stator_mags.geo" ;
Include "pdd_rotor1.geo" ;
Include "pdd_rotor2.geo" ;

Mesh.CharacteristicLengthFactor = 1;
//Mesh 2;

// For nice visualisation...
Mesh.Light = 0 ;
Hide { Line{ Line '*' }; }
Hide { Point{ Point '*' }; }

Physical Line("NICEPOS") = { nicepos_rotor[],nicepos_rotor2[],nicepos_stator_mag[] };
Show { Line{ nicepos_rotor[],nicepos_rotor2[], nicepos_stator_mag[] }; }

//For post-processing...
View[PostProcessing.NbViews-1].Light = 0;
View[PostProcessing.NbViews-1].NbIso = 60;              // Number of intervals
View[PostProcessing.NbViews-1].IntervalsType = 1;       // 1 - Iso Values; 2 - Continuous Map
View[PostProcessing.NbViews-1].LineWidth = 2.5;           // espessura linha
View[PostProcessing.NbViews-1].ColormapNumber = 2;      // color map - 2 default - 10 B&W

General.Trackball = 0;
General.RotationX = 0;
General.RotationY = 0;
General.RotationZ = 0;
General.Color.Background = White;
General.Color.Foreground = Black;
General.Color.Text = Black;
General.Orthographic = 0;
General.Axes = 0;
General.SmallAxes = 0;
