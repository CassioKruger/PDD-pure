//Maio, 2019 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd-puro (sem o gerador)

Geometry.AutoCoherence = 0;

//rotor2
TopModulator = 156.6*u;
BottomModulator = 142*u;
BottomSliding = BottomModulator-AG;
TopSliding = TopModulator+AG;

//Slot dimensions
Modulator_ang = (7.2/2)*deg2rad;

 //build stator slots
For i In {0:N_ss_mag-1}
	 //build two halfs
	 For half In {0:1}

	//Points
	dP=newp;
	 Point(dP+0) = {0,0,0,1.0};

	 Point(dP+1) = {0,BottomSliding,0,pMB};																			//bottom sliding center
	 Point(dP+2) = {Cos((Pi/2)-Modulator_ang)*(BottomSliding),Sin((Pi/2)-Modulator_ang)*(BottomSliding),0,pMB};		//bottom sliding sector
	 Point(dP+3) = {0,BottomModulator,0,psl};																			//bottom modulator center
	 Point(dP+4) = {Cos((Pi/2)-Modulator_ang)*(BottomModulator),Sin((Pi/2)-Modulator_ang)*(BottomModulator),0,psl};	//bottom modulator sector
	 Point(dP+5) = {0,TopModulator,0,psl};																				//top modulator center
	 Point(dP+6) = {Cos((Pi/2)-Modulator_ang)*(TopModulator),Sin((Pi/2)-Modulator_ang)*(TopModulator),0,psl};			//top modulator sector
 	 Point(dP+7) = {0,TopSliding,0,pMB};																				//top sliding center
	 Point(dP+8) = {Cos((Pi/2)-Modulator_ang)*(TopSliding),Sin((Pi/2)-Modulator_ang)*(TopSliding),0,pMB};				//top sliding sector

		// rotate the built points to the i-th slot position
	 For t In {dP+0:dP+8}
	 	Rotate {{0,0,1},{0,0,0}, Rotor2Angle_R+2*Pi*i/NbrSectStatorMagTot} {Point{t};}
	 EndFor

	 If (half==1) //second half
		 For t In {dP+0:dP+8}
		 	Symmetry {Cos(Rotor2Angle_S+2*Pi*i/NbrSectStatorMagTot), Sin(Rotor2Angle_S+2*Pi*i/NbrSectStatorMagTot),0,0} {Point{t};}
		 EndFor
	 EndIf

	//Lines
	dR=newl-1;
	 Line(dR+1) = {dP+1,dP+3}; 				//bottom sliding center
	 Circle(dR+2) = {dP+1,dP+0,dP+2};		//bottom sliding
	 Line(dR+3) = {dP+2,dP+4}; 				//bottom sliding sector
	 Circle(dR+4) = {dP+3,dP+0,dP+4};		//bottom modulator

	 Line(dR+5) = {dP+3,dP+5};				//modulator center
	 Line(dR+6) = {dP+4,dP+6};				//modulator sector
	 Circle(dR+7) = {dP+5,dP+0,dP+6};		//top modulator
	 Transfinite Line {dR+7, dR+4} = 30 Using Progression 1;

	 Line(dR+8) = {dP+5,dP+7}; 				//top sliding center
	 Line(dR+9) = {dP+6,dP+8}; 				//top sliding sector
	 Circle(dR+10) = {dP+7,dP+0,dP+8};		//top sliding

	 Rotor2TopSliding_[] += {dR+10};
	 Rotor2BottomSliding_[] += {dR+2};

	 //Periodic boundary
	 If (Qs_mag != N_ss_mag)
	 	 //right boundary
		 If (i == 0 && half==0)
		 	Rotor2Period_Right_[] = {dR+6};
		 EndIf
		 //left boundary
		 If (i == (N_ss_mag-1) && half==1)
		 	Rotor2Period_Left_[] = {dR+6};
		 EndIf
	 EndIf
	 		 	//if mirrorred, then the lines order is reversed
				//direction is important defining the Line Loops
	 rev = (half ? -1 : 1);

	 If (i%2==0)
		 Line Loop(newll) = {dR+4,dR+6,-(dR+7),-(dR+5)};
		 dH = news; Plane Surface(news) = -rev*{newll-1};
		 Rotor2Iron_[] += dH;
	 EndIf

	 If (i%2!=0)
		 Line Loop(newll) = {dR+4,dR+6,-(dR+7),-(dR+5)};
		 dH = news; Plane Surface(news) = -rev*{newll-1};
		 Rotor2Air_[] += dH;
	 EndIf

	 	//airgap rotor
	 Line Loop(newll) = {dR+7, dR+9, -(dR+10), -(dR+8)};
	 dH = news; Plane Surface(news) = rev*{newll-1};
	 Rotor2AirgapLayerTop_[] += dH;

	 Line Loop(newll) = {dR+2, dR+3, -(dR+4), -(dR+1)};
	 dH = news; Plane Surface(news) = rev*{newll-1};
	 Rotor2AirgapLayerBottom_[] += dH;

	 EndFor
EndFor

// Completing moving band top
NN = #Rotor2TopSliding_[] ;
k1 = (NbrStatorPolesInModel==1)?NbrStatorPolesInModel:NbrStatorPolesInModel+1;
For k In {k1:NbrStatorPolesTot-1}
  Rotor2TopSliding_[] += Rotate {{0, 0, 1}, {0, 0, 0}, k*NbrSectStatorMag*2*(Pi/NbrSectStatorMagTot)} { Duplicata{ Line{Rotor2TopSliding_[{0:NN-1}]};} };
EndFor

// Completing moving band bot
NN = #Rotor2BottomSliding_[] ;
k1 = (NbrStatorPolesInModel==1)?NbrStatorPolesInModel:NbrStatorPolesInModel+1;
For k In {k1:NbrStatorPolesTot-1}
  Rotor2BottomSliding_[] += Rotate {{0, 0, 1}, {0, 0, 0}, k*NbrSectStatorMag*2*(Pi/NbrSectStatorMagTot)} { Duplicata{ Line{Rotor2BottomSliding_[{0:NN-1}]};} };
EndFor


//---------------------------------rotor-----------------------------------------//
Physical Surface(ROTOR2_FE) = {Rotor2Iron_[]};
Physical Surface(ROTOR2_AIRGAPTOP) = {Rotor2AirgapLayerTop_[]};
Physical Surface(ROTOR2_AIRGAPBOTTOM) = {Rotor2AirgapLayerBottom_[]};
Physical Surface(ROTOR2_AIR) = {Rotor2Air_[]};

Color Honeydew4 {Surface{Rotor2Iron_[]};}
Color SkyBlue {Surface{Rotor2AirgapLayerTop_[]};}
Color SkyBlue {Surface{Rotor2AirgapLayerBottom_[]};}
Color SkyBlue {Surface{Rotor2Air_[]};}

Physical Line(ROTOR2_TOP_BND_MOVING_BAND) = {Rotor2TopSliding_[]};
Physical Line(ROTOR2_BOTTOM_BND_MOVING_BAND) = {Rotor2BottomSliding_[]};

If (Qr != N_rs)
	Physical Line(ROTOR2_BND_A0) = {Rotor2Period_Right_[]};
	Physical Line(ROTOR2_BND_A1) = {Rotor2Period_Left_[]};
EndIf

Coherence;

nicepos_rotor2[] = CombinedBoundary{Surface{Rotor2Iron_[]};};
nicepos_rotor2[] += CombinedBoundary{Surface{Rotor2AirgapLayerTop_[]};};
nicepos_rotor2[] += CombinedBoundary{Surface{Rotor2AirgapLayerBottom_[]};};
nicepos_rotor2[] += CombinedBoundary{Surface{Rotor2Air_[]};};
