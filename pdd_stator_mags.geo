//Maio, 2019 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd-puro (sem o gerador)

Geometry.AutoCoherence = 0;

//Stator airgap
R_gs = R_s_mag_in-AG;

//Stator magnets
SMag_ang = (7.2/2)*deg2rad;


//build stator slots
For i In {0:N_ss_mag-1}
	 //build two halfs
	 For half In {0:1}

	//entrada direita do slot - começando pelos imas
	//Points
	dP=newp;
	 Point(dP+0) = {0,0,0,1.0};

	 Point(dP+1) = {0, R_s_mag_in, 0, pMB};												//magnet center
	 Point(dP+2) = {R_s_mag_in*Sin(SMag_ang), R_s_mag_in*Cos(SMag_ang), 0, pMB};	//magnet sector (borda)
	 Point(dP+3) = {R_sin*Sin(SMag_ang),R_sin*Cos(SMag_ang),0,pslo};						//magnet sector to inner stator
	 Point(dP+4) = {0, R_sin, 0, pslo};											//magnet center to inner stator

	 Point(dP+5) = {0, R_gs, 0, pMB};												//sliding center
	 Point(dP+6) = {R_gs*Sin(SMag_ang), R_gs*Cos(SMag_ang), 0, pMB}; 				//sliding sector


	 // rotate the built points to the i-th slot position
	 For t In {dP+0:dP+6}
	 	Rotate {{0,0,1},{0,0,0}, 2*Pi*i/Qs_mag+2*Pi/Qs_mag/2} {Point{t};}
	 EndFor

	 If (half==1) //second half
		 For t In {dP+0:dP+6}
		 	Symmetry {Cos(2*Pi*i/Qs_mag+2*Pi/Qs_mag/2),Sin(2*Pi*i/Qs_mag+2*Pi/Qs_mag/2),0,0} {Point{t};}
		 EndFor
	 EndIf

	//Lines
	dR=newl-1;
	 Line(dR+1) = {dP+1,dP+4};															//magnet center
	 Line(dR+2) = {dP+2,dP+3};															//magnet sector (borda)
	 Circle(dR+3) = {dP+1,dP+0,dP+2};													//bottom magnet/top sliding
	 Circle(dR+4) = {dP+4,dP+0,dP+3};													//top magnet

	 Line(dR+5) = {dP+5,dP+1};															//sliding center
	 Line(dR+6) = {dP+6,dP+2};															//sliding sector (borda)
	 Circle(dR+7) = {dP+5,dP+0,dP+6};													//bottom sliding

	 StatorSliding_[] += {dR+7};

	 	//if mirrorred, then the lines order is reversed
		//direction is important defining the Line Loops
	 rev = (half ? -1 : 1);

	 Line Loop(newll) = {dR+7, dR+6, -(dR+3), -(dR+5)};
	 dH = news; Plane Surface(news) = rev*{newll-1};
	 StatorAirgapLayer_[] += dH;

	 If (i%2==0)
			//surface of magnetics (NORTE)
		 Line Loop(newll) = {dR+3,dR+2,-(dR+4),-(dR+1)};
		 dH = news; Plane Surface(news) = -rev*{newll-1};
		 StatorMagneticsNorth_[] += dH;
	 EndIf

	 If (i%2!=0)
	 			//surface of magnetics (SUL)
		 Line Loop(newll) = {dR+3,dR+2,-(dR+4),-(dR+1)};
		 dH = news; Plane Surface(news) = -rev*{newll-1};
		 StatorMagneticsSouth_[] += dH;
	 EndIf

	 //surface of magnetics
	 Line Loop(newll) = {dR+3,dR+2,-(dR+4),-(dR+1)};
	 dH = news; Plane Surface(news) = -rev*{newll-1};
	 StatorMagnetics_[] += dH;

	 EndFor
EndFor

// Completing moving band
NN = #StatorSliding_[] ;
k1 = (NbrStatorPolesInModel==1)?NbrStatorPolesInModel:NbrStatorPolesInModel+1;
For k In {k1:NbrStatorPolesTot-1}
  StatorSliding_[] += Rotate {{0, 0, 1}, {0, 0, 0}, k*NbrSectStatorMag*2*(Pi/NbrSectStatorMagTot)} { Duplicata{ Line{StatorSliding_[{0:NN-1}]};} };
EndFor

//--------------------------------SURFACES--------------------------------------------------------------//

//Physical Surface("StatorMagNORTE") = {StatorMagneticsNorth_[]};
Color Orchid {Surface{StatorMagneticsNorth_[]};}
If (N_ss_mag>1)
	//Physical Surface("StatorMagSUL") = {StatorMagneticsSouth_[]};
	Color Blue {Surface{StatorMagneticsSouth_[]};}
EndIf

auxiliar = 0;

NN = (Flag_Symmetry)?NbrStatorPolesInModel:NbrStatorPolesTot;
Printf("stator magnet %g",NN);
For k In {0:(NN-1)*2:2}
  Physical Surface(Sprintf("stator magnet %g",auxiliar),STATOR_MAGNET+auxiliar) = {StatorMagnetics_[k],StatorMagnetics_[k+1]}; // Magnets
  auxiliar++;
EndFor

Physical Line(STATOR_BND_MOVING_BAND) = {StatorSliding_[]};

Physical Surface("StatorAirgap", STATOR_AIRGAP) = {StatorAirgapLayer_[]};
Color SkyBlue {Surface{StatorAirgapLayer_[]};}

Coherence;

nicepos_stator_mag[] = CombinedBoundary{Surface{StatorMagneticsSouth_[]};};
nicepos_stator_mag[] += CombinedBoundary{Surface{StatorMagneticsNorth_[]};};
nicepos_stator_mag[] += CombinedBoundary{Surface{StatorAirgapLayer_[]};};
