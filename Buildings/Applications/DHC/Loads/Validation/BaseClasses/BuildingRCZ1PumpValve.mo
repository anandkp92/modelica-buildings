within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model BuildingRCZ1PumpValve
  "RC building model with distribution pumps and mixing valves (1 zone)"
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium = Buildings.Media.Water,
    have_eleHea=false,
    have_eleCoo=false,
    have_weaBus=true);
  package Medium2 = Buildings.Media.Air
    "Load side medium";
  parameter Integer nZon = 1
    "Number of thermal zones";
  Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[2](
    each outSkyCon=true,
    each outGroCon=true,
    each til=1.5707963267949,
    each lat=0.87266462599716,
    azi={3.1415926535898,4.7123889803847})
    "Calculates diffuse solar radiation on titled surface for both directions"
    annotation (Placement(transformation(extent={{-94,98},{-74,118}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[2](
    each til=1.5707963267949,
    each lat=0.87266462599716,
    azi={3.1415926535898,4.7123889803847})
    "Calculates direct solar radiation on titled surface for both directions"
    annotation (Placement(transformation(extent={{-94,130},{-74,150}})));
  Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDouPan(n=2, UWin=2.1)
    "Correction factor for solar transmission"
    annotation (Placement(transformation(extent={{-20,132},{0,152}})));
  Buildings.ThermalZones.ReducedOrder.RC.OneElement thermalZoneOneElement(
    VAir=52.5,
    hRad=4.999999999999999,
    hConWin=2.7000000000000006,
    gWin=1,
    ratioWinConRad=0.09,
    hConExt=2.0490178828959134,
    nExt=1,
    RExt={0.00331421908725},
    CExt={5259932.23},
    RWin=0.01642857143,
    RExtRem=0.1265217391,
    nOrientations=2,
    AWin={7,7},
    ATransparent={7,7},
    AExt={3.5,8},
    redeclare package Medium = Medium2,
    extWallRC(thermCapExt(each der_T(fixed=true))),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=295.15,
    nPorts=2)       "Thermal zone"
    annotation (Placement(transformation(extent={{18,68},{66,104}})));
  Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow
    eqAirTemp(
    n=2,
    wfGro=0,
    wfWall={0.3043478260869566,0.6956521739130435},
    wfWin={0.5,0.5},
    withLongwave=true,
    aExt=0.7,
    hConWallOut=20.0,
    hRad=5.0,
    hConWinOut=20.0,
    TGro=285.15) "Computes equivalent air temperature"
    annotation (Placement(transformation(extent={{-50,64},{-30,84}})));
  Modelica.Blocks.Math.Add solRad[2]
    "Sums up solar radiation of both directions"
    annotation (Placement(transformation(extent={{-64,84},{-54,94}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribed temperature for exterior walls outdoor surface temperature"
    annotation (Placement(transformation(extent={{-18,72},{-6,84}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem1
    "Prescribed temperature for windows outdoor surface temperature"
    annotation (Placement(transformation(extent={{-18,92},{-6,104}})));
  Modelica.Thermal.HeatTransfer.Components.Convection theConWin
    "Outdoor convective heat transfer of windows"
    annotation (Placement(transformation(extent={{12,94},{2,104}})));
  Modelica.Thermal.HeatTransfer.Components.Convection theConWall
    "Outdoor convective heat transfer of walls"
    annotation (Placement(transformation(extent={{10,84},{0,74}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow perRad
    "Radiative heat flow of persons"
    annotation (Placement(transformation(extent={{22,36},{42,56}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow perCon
    "Convective heat flow of persons"
    annotation (Placement(transformation(extent={{22,20},{42,40}})));
  Modelica.Blocks.Sources.CombiTimeTable intGai(
    table=[0,0,0,0; 3600,0,0,0; 7200,0,0,0; 10800,0,0,0; 14400,0,0,0;
        18000,0,0,0; 21600,0,0,0; 25200,0,0,0; 25200,80,80,200; 28800,80,
        80,200; 32400,80,80,200; 36000,80,80,200; 39600,80,80,200; 43200,
        80,80,200; 46800,80,80,200; 50400,80,80,200; 54000,80,80,200;
        57600,80,80,200; 61200,80,80,200; 61200,0,0,0; 64800,0,0,0; 72000,
        0,0,0; 75600,0,0,0; 79200,0,0,0; 82800,0,0,0; 86400,0,0,0],
    columns={2,3,4},
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Table with profiles for persons (radiative and convective) and machines
    (convective)"
    annotation (Placement(transformation(extent={{-28,38},{-12,54}})));
  Modelica.Blocks.Sources.Constant const[2](each k=0)
    "Sets sunblind signal to zero (open)"
    annotation (Placement(transformation(extent={{-46,92},{-40,98}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow macConv
    "Convective heat flow of machines"
    annotation (Placement(transformation(extent={{22,2},{42,22}})));
  Modelica.Blocks.Sources.Constant alphaWall(k=25*11.5)
    "Outdoor coefficient of heat transfer for walls"
    annotation (Placement(
    transformation(
    extent={{-4,-4},{4,4}},
    rotation=90,
    origin={4,62})));
  Modelica.Blocks.Sources.Constant alphaWin(k=20*14)
    "Outdoor coefficient of heat transfer for windows"
    annotation (Placement(
    transformation(
    extent={{4,-4},{-4,4}},
    rotation=90,
    origin={6,116})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20)
    "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-300,250},{-280,270}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{-260,250},{-240,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=24)
    "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-300,210},{-280,230}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2
    annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=2)
    annotation (Placement(transformation(extent={{260,70},{280,90}})));
  Buildings.Applications.DHC.Loads.Validation.BaseClasses.Terminal4PipesFluidPorts
    terUni(
      redeclare package Medium1 = Medium,
      redeclare package Medium2 = Medium2,
      QHea_flow_nominal=500,
      QCoo_flow_nominal=2000,
      T_aLoaHea_nominal=293.15,
      T_aLoaCoo_nominal=297.15,
      T_bHeaWat_nominal=308.15,
      T_bChiWat_nominal=285.15,
      T_aHeaWat_nominal=313.15,
      T_aChiWat_nominal=280.15,
      mLoaHea_flow_nominal=1,
      mLoaCoo_flow_nominal=1)
    "Terminal unit"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    redeclare package Medium = Medium,
    m_flow_nominal=terUni.mHeaWat_flow_nominal,
    have_pum=true,
    have_val=true,
    dp_nominal=100000,
    nPorts_a1=1,
    nPorts_b1=1)
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{-100, -120},{-80,-100}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    redeclare package Medium = Medium,
    m_flow_nominal=terUni.mChiWat_flow_nominal,
    disTyp=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
    have_pum=true,
    have_val=true,
    dp_nominal=100000,
    nPorts_a1=1,
    nPorts_b1=1)
    "Chilled water distribution system"
    annotation (Placement(transformation(extent={{-100, -160},{-80,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetSecHea(k=35)
    "Heating water secondary supply temperature setpoint"
    annotation (Placement(transformation(extent={{-260,-180},{-240,-160}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC3
    annotation (Placement(transformation(extent={{-220,-180},{-200,-160}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC4
    annotation (Placement(transformation(extent={{-220,-220},{-200,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetSecChi(k=16)
    "Chilled water secondary supply temperature setpoint"
    annotation (Placement(transformation(extent={{-260,-220},{-240,-200}})));
equation
  connect(eqAirTemp.TEqAirWin,preTem1. T)
    annotation (Line(
    points={{-29,77.8},{-26,77.8},{-26,98},{-19.2,98}},
                                                   color={0,0,127}));
  connect(eqAirTemp.TEqAir,preTem. T)
    annotation (Line(points={{-29,74},{-22,74},{-22,78},{-19.2,78}},
    color={0,0,127}));
  connect(intGai.y[1],perRad. Q_flow)
    annotation (Line(points={{-11.2,46},{22,46}},
                                      color={0,0,127}));
  connect(intGai.y[2],perCon. Q_flow)
    annotation (Line(points={{-11.2,46},{-11.2,30},{22,30}},color={0,0,127}));
  connect(intGai.y[3],macConv. Q_flow)
    annotation (Line(points={{-11.2,46},{28,46},{28,12},{22,12}},
                                      color={0,0,127}));
  connect(const.y,eqAirTemp. sunblind)
    annotation (Line(points={{-39.7,95},{-38,95},{-38,86},{-40,86}},
    color={0,0,127}));
  connect(HDifTil.HSkyDifTil,corGDouPan. HSkyDifTil)
    annotation (Line(
    points={{-73,114},{-32,114},{-32,144},{-22,144}},  color={0,0,127}));
  connect(HDirTil.H,corGDouPan. HDirTil)
    annotation (Line(points={{-73,140},{-36,140},{-36,148},{-22,148}},
    color={0,0,127}));
  connect(HDirTil.H,solRad. u1)
    annotation (Line(points={{-73,140},{-68,140},{-68,92},{-65,92}},
                   color={0,0,127}));
  connect(HDirTil.inc,corGDouPan. inc)
    annotation (Line(points={{-73,136},{-22,136}},
                                               color={0,0,127}));
  connect(HDifTil.H,solRad. u2)
    annotation (Line(points={{-73,108},{-70,108},{-70,86},{-65,86}},
                 color={0,0,127}));
  connect(HDifTil.HGroDifTil,corGDouPan. HGroDifTil)
    annotation (Line(
    points={{-73,102},{-30,102},{-30,140},{-22,140}},
                                              color={0,0,127}));
  connect(solRad.y,eqAirTemp. HSol)
    annotation (Line(points={{-53.5,89},{-52,89},{-52,80}},
    color={0,0,127}));
  connect(perRad.port,thermalZoneOneElement. intGainsRad)
    annotation (Line(
    points={{42,46},{104,46},{104,94},{66,94}},
    color={191,0,0}));
  connect(theConWin.solid,thermalZoneOneElement. window)
    annotation (
    Line(points={{12,99},{14,99},{14,90},{18,90}},   color={191,0,0}));
  connect(preTem1.port,theConWin. fluid)
    annotation (Line(points={{-6,98},{2,98},{2,99}},   color={191,0,0}));
  connect(thermalZoneOneElement.extWall,theConWall. solid)
    annotation (Line(points={{18,82},{14,82},{14,79},{10,79}},
    color={191,0,0}));
  connect(theConWall.fluid,preTem. port)
    annotation (Line(points={{0,79},{-2,79},{-2,78},{-6,78}},
                                                           color={191,0,0}));
  connect(alphaWall.y,theConWall. Gc)
    annotation (Line(points={{4,66.4},{4,74},{5,74}},     color={0,0,127}));
  connect(alphaWin.y,theConWin. Gc)
    annotation (Line(points={{6,111.6},{6,104},{7,104}}, color={0,0,127}));
  connect(macConv.port,thermalZoneOneElement. intGainsConv)
    annotation (
    Line(points={{42,12},{98,12},{98,90},{66,90}},            color={191,
    0,0}));
  connect(perCon.port,thermalZoneOneElement. intGainsConv)
    annotation (
    Line(points={{42,30},{98,30},{98,90},{66,90}},   color={191,0,0}));
  connect(corGDouPan.solarRadWinTrans,thermalZoneOneElement. solRad)
    annotation (Line(points={{1,142},{14,142},{14,101},{17,101}},      color={0,
    0,127}));
  connect(weaBus.TBlaSky, eqAirTemp.TBlaSky) annotation (Line(
      points={{1,300},{-186,300},{-186,74},{-52,74}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TDryBul, eqAirTemp.TDryBul) annotation (Line(
      points={{1,300},{-186,300},{-186,68},{-52,68}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, HDifTil[2].weaBus) annotation (Line(
      points={{1,300},{-186,300},{-186,108},{-94,108}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, HDirTil[1].weaBus) annotation (Line(
      points={{1,300},{-186,300},{-186,140},{-94,140}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, HDirTil[2].weaBus) annotation (Line(
      points={{1,300},{-186,300},{-186,140},{-94,140}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, HDifTil[1].weaBus) annotation (Line(
      points={{1,300},{-186,300},{-186,108},{-94,108}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(minTSet.y, from_degC1.u) annotation (Line(points={{-278,260},{-262,
          260}},                                                                  color={0,0,127}));
  connect(thermalZoneOneElement.ports[1], terUni.port_aLoa)
    annotation (Line(points={{55.475,68.05},{86.5,68.05},{86.5,-41.6667},{-140,
          -41.6667}},                                                            color={0,127,255}));
  connect(terUni.port_bLoa, thermalZoneOneElement.ports[2])
    annotation (Line(points={{-160,-41.6667},{-206,-41.6667},{-206,56},{58.525,
          56},{58.525,68.05}},                                                              color={0,127,255}));
  connect(ports_a[1], disFloHea.port_a) annotation (Line(points={{-300,0},{-280,
          0},{-280,-110},{-100,-110}}, color={0,127,255}));
  connect(disFloHea.port_b, ports_b[1]) annotation (Line(points={{-80,-110},{280,
          -110},{280,0},{300,0}}, color={0,127,255}));
  connect(maxTSet.y, from_degC2.u) annotation (Line(points={{-278,220},{-262,
          220}},                                                                  color={0,0,127}));
  connect(ports_a[2], disFloCoo.port_a) annotation (Line(points={{-300,0},{-280,
          0},{-280,-150},{-100,-150}}, color={0,127,255}));
  connect(disFloCoo.port_b, ports_b[2]) annotation (Line(points={{-80,-150},{280,
          -150},{280,0},{300,0}}, color={0,127,255}));
  connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,260},{
          -200,260},{-200,-43.3333},{-160.833,-43.3333}},
                                                     color={0,0,127}));
  connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,220},{
          -200,220},{-200,-46},{-160.833,-46},{-160.833,-46.6667}},
                                                               color={0,0,127}));
  connect(terUni.port_bChiWat, disFloCoo.ports_a1[1]) annotation (Line(points={{-140,
          -56.6667},{-90,-56.6667},{-90,-56},{-40,-56},{-40,-144},{-80,-144}},
        color={0,127,255}));
  connect(terUni.port_bHeaWat, disFloHea.ports_a1[1]) annotation (Line(points={{-140,
          -58.3333},{-100,-58.3333},{-100,-60},{-60,-60},{-60,-104},{-80,-104}},
        color={0,127,255}));
  connect(disFloHea.ports_b1[1], terUni.port_aHeaWat) annotation (Line(points={{-100,
          -104},{-180,-104},{-180,-58.3333},{-160,-58.3333}}, color={0,127,255}));
  connect(disFloCoo.ports_b1[1], terUni.port_aChiWat) annotation (Line(points={{-100,
          -144},{-200,-144},{-200,-56.6667},{-160,-56.6667}},
                                                        color={0,127,255}));
  connect(terUni.QActHea_flow, QHea_flow) annotation (Line(points={{-139.167,
          -43.3333},{82,-43.3333},{82,280},{320,280}},
                                          color={0,127,255}));
  connect(terUni.QActCoo_flow, QCoo_flow) annotation (Line(points={{-139.167,
          -45},{83.4165,-45},{83.4165,240},{320,240}}, color={0,0,127}));
  connect(terUni.PFan, PFan) annotation (Line(points={{-139.167,-50},{220,-50},
          {220,120},{320,120}}, color={0,0,127}));
  connect(terUni.mReqHeaWat_flow, disFloHea.mReq_flow[1]) annotation (Line(points={{
          -139.167,-53.3333},{-139.167,-115.25},{-101,-115.25},{-101,-114}},
        color={0,0,127}));
  connect(terUni.mReqChiWat_flow, disFloCoo.mReq_flow[1]) annotation (Line(points={{
          -139.167,-55},{-139.167,-54},{-140,-54},{-140,-154},{-101,-154}},
                                                            color={0,0,127}));
  connect(disFloHea.PPum, mulSum.u[1]) annotation (Line(points={{-79,-118},{240,
          -118},{240,81},{258,81}}, color={0,0,127}));
  connect(disFloCoo.PPum, mulSum.u[2]) annotation (Line(points={{-79,-158},{244,
          -158},{244,80},{258,80},{258,79}}, color={0,0,127}));
  connect(mulSum.y, PPum) annotation (Line(points={{282,80},{298,80},{298,80},{
          320,80}}, color={0,0,127}));
  connect(TSetSecHea.y, from_degC3.u)
    annotation (Line(points={{-238,-170},{-222,-170}}, color={0,0,127}));
  connect(TSetSecChi.y, from_degC4.u)
    annotation (Line(points={{-238,-210},{-222,-210}}, color={0,0,127}));
  connect(from_degC3.y, disFloHea.TSupSet) annotation (Line(points={{-198,-170},
          {-150,-170},{-150,-118},{-101,-118}}, color={0,0,127}));
  connect(from_degC4.y, disFloCoo.TSupSet) annotation (Line(points={{-198,-210},
          {-140,-210},{-140,-158},{-101,-158}}, color={0,0,127}));
  annotation (
  Documentation(info="<html>
  <p>
  This is a simplified building model with:
  </p>
  <ul>
  <li> one instance of
  <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.RC.OneElement\">
  Buildings.ThermalZones.ReducedOrder.RC.OneElement</a> providing the temperature of one cooling load and one
  heating load. The required cooling and heating heat flow rates to maintain the maximum and minimum
  temperature setpoints are computed by means of a PI controller;
  </li>
  <li>
  one additional heating load which temperature is computed with
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE</a>
  and the required heating heat flow rate is provided by a time function.
  </li>
  </ul>
  <p>
  </p>
  </html>"),
  Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end BuildingRCZ1PumpValve;