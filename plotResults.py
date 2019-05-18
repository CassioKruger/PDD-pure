import numpy as np 
import pandas as pd 
from matplotlib import pyplot as plt 

flag = input("Tensao e corrente = 1 \n Torques = 2 \n Posicao e velocidade = 3\n")

tempo = pd.read_csv("pdd1 v5/res/Ua.dat",sep='  ', header=None, index_col=None,usecols=[0],engine= 'python')
tempoPosVel = pd.read_csv("pdd1 v5/res/P.dat",sep='  ', header=None, index_col=None,usecols=[0],engine= 'python')

tensaoUa = pd.read_csv("pdd1 v5/res/Ua.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
tensaoUb = pd.read_csv("pdd1 v5/res/Ub.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
tensaoUc = pd.read_csv("pdd1 v5/res/Uc.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

correnteIa = pd.read_csv("pdd1 v5/res/Ia.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
correnteIb = pd.read_csv("pdd1 v5/res/Ib.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
correnteIc = pd.read_csv("pdd1 v5/res/Ic.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

torqueRotor = pd.read_csv("pdd1 v5/res/Tr.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
torqueEstator = pd.read_csv("pdd1 v5/res/Ts.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

posRotor1Deg = pd.read_csv("pdd1 v5/res/P_deg.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
posRotor1Rad = pd.read_csv("pdd1 v5/res/P.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
veloRotor1Rad_sec = pd.read_csv("pdd1 v5/res/V.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
veloRotor1Rpm = pd.read_csv("pdd1 v5/res/Vrpm.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

posRotor2Deg = pd.read_csv("pdd1 v5/res/P_deg2.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
posRotor2Rad = pd.read_csv("pdd1 v5/res/P2.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
veloRotor2Rad_sec = pd.read_csv("pdd1 v5/res/V2.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
veloRotor2Rpm = pd.read_csv("pdd1 v5/res/Vrpm2.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

if (flag == '1'):
    print(flag)
    #          (linhas,colunas,posicao)
    plt.figure(1)
    plt.subplot(2,1,1)
    plt.plot(tempo,tensaoUa,color = [0, 0.4470, 0.7410])
    plt.plot(tempo,tensaoUb,color = [0.8500, 0.3250, 0.0980])
    plt.plot(tempo,tensaoUc,color = [0.4660, 0.6740, 0.1880])

    plt.title("Tensao e Corrente")
    plt.xlabel("Tempo (s)")
    plt.ylabel("Tensao (V)")
    plt.legend(["Va","Vb","Vc"])

    plt.subplot(2,1,2)
    plt.plot(tempo,correnteIa,color = [0, 0.4470, 0.7410])
    plt.plot(tempo,correnteIb,color = [0.8500, 0.3250, 0.0980])
    plt.plot(tempo,correnteIc,color = [0.4660, 0.6740, 0.1880])

    plt.xlabel("Tempo (s)")
    plt.ylabel("Corrente (A)")
    plt.legend(["Ia","Ib","Ic"])
    plt.show()
    
##-----------------------##
if (flag == '2'):
    print(flag)
    plt.figure(1)
    plt.subplot(2,1,1)
    plt.plot(tempo,torqueRotor,color = [0, 0.4470, 0.7410])
    plt.plot(tempo,torqueEstator,color = [0.8500, 0.3250, 0.0980])

    plt.title("Torques")
    plt.xlabel("Tempo (s)")
    plt.ylabel("Torque (Nm)")
    plt.legend(["Tr","Ts"])
    plt.show()
    
##-----------------------##
if (flag == '3'):
    print(flag)
    plt.figure(1)

    plt.title("Rotor 1")
    # pos rotor 1
    plt.subplot(2,2,1)
    plt.plot(tempoPosVel,posRotor1Deg,color = [0, 0.4470, 0.7410])
    plt.plot(tempoPosVel,posRotor1Rad,color = [0.8500, 0.3250, 0.0980])
    plt.xlabel("Tempo (s)")
    plt.ylabel("Posicao")
    plt.legend(["Deg","Rad"])

    # vel rotor 1
    plt.subplot(2,2,3)
    plt.plot(tempoPosVel,veloRotor1Rad_sec,color = [0, 0.4470, 0.7410])
    plt.plot(tempoPosVel,veloRotor1Rpm,color = [0.8500, 0.3250, 0.0980])
    plt.xlabel("Tempo (s)")
    plt.ylabel("Velocidade")
    plt.legend(["[Rad/s]","[RPM]"])

    plt.title("Rotor 2")
    # pos rotor 2
    plt.subplot(2,2,2)
    plt.plot(tempoPosVel,posRotor2Deg,color = [0, 0.4470, 0.7410])
    plt.plot(tempoPosVel,posRotor2Rad,color = [0.8500, 0.3250, 0.0980])
    plt.xlabel("Tempo (s)")
    plt.ylabel("Posicao")
    plt.legend(["Deg","Rad"])

    # vel rotor 2
    plt.subplot(2,2,4)
    plt.plot(tempoPosVel,veloRotor2Rad_sec,color = [0, 0.4470, 0.7410])
    plt.plot(tempoPosVel,veloRotor2Rpm,color = [0.8500, 0.3250, 0.0980])
    plt.xlabel("Tempo (s)")
    plt.ylabel("Velocidade")
    plt.legend(["[Rad/s]","[RPM]"])
    plt.show()
    




