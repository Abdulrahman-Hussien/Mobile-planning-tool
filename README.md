# Mobile-planning-tool
### A simple planning tool for a service provider that owns 340 channels in the 900 MHz band.  
The code asks from users for the GOS, city area, user density, minimum signal to Intensity ratio (SIR<sub>min</sub>), and sectorization method. Then, it should produce the following design parameters:  
1) Cluster Size.  
2) Number of cells.  
3) Cell radius.  
4) Traffic intensity per cell, and traffic intensity per sector.  
5) Base station transmitted power.  
6) A plot for the Mobile Station received power in dBm versus the receiver distance from the Base Station.  
  
The desgin used for the planning tool was based on the Hata model assuming urban-medium city, and assuming blocked calls are cleared in this system. 

**Note:** *The effective heights of BS and MS equal 20 and 1.5 meters, respectively. Assume MS sensitivity equals −95 dBm, the traffic intensity per user equals 0.025 Erlang and the path loss exponent equals 4.*  
 
*Project was done on May 2022*
