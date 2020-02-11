within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
partial model PartialFanCoil4Pipe
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Air,
    final have_watHea=true,
    final have_watCoo=true,
    final have_fan=true,
    final mHeaWat_flow_nominal=abs(QHea_flow_nominal/cpHeaWat_nominal/(
      T_aHeaWat_nominal - T_bHeaWat_nominal)),
    final mChiWat_flow_nominal=abs(QCoo_flow_nominal/cpChiWat_nominal/(
      T_aChiWat_nominal - T_bChiWat_nominal)));
  import hexConfiguration = Buildings.Fluid.Types.HeatExchangerConfiguration;
  parameter hexConfiguration hexConHea=
    hexConfiguration.CounterFlow
    "Heating heat exchanger configuration";
  parameter hexConfiguration hexConCoo=
    hexConfiguration.CounterFlow
    "Cooling heat exchanger configuration";
  Buildings.Controls.OBC.CDL.Continuous.LimPID conHea(
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=false,
    yMin=0) "PI controller for heating"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium=Medium2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=max({mLoaHea_flow_nominal, mLoaCoo_flow_nominal}),
    redeclare Fluid.Movers.Data.Generic per,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=400,
    final allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexHea(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final configuration=hexConHea,
    final m1_flow_nominal=mHeaWat_flow_nominal,
    final m2_flow_nominal=mLoaHea_flow_nominal,
    final dp1_nominal=0,
    dp2_nominal=200,
    final Q_flow_nominal=QHea_flow_nominal,
    final T_a1_nominal=T_aHeaWat_nominal,
    final T_a2_nominal=T_aLoaHea_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
    annotation (Placement(transformation(extent={{-80,4}, {-60,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaFloNom(k=mHeaWat_flow_nominal)
    annotation (Placement(transformation(extent={{40,210},{60,230}})));
  Modelica.Blocks.Sources.RealExpression Q_flowHea(y=hexHea.Q2_flow)
    annotation (Placement(transformation(extent={{120,210},{140,230}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexCoo(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final configuration=hexConCoo,
    final m1_flow_nominal=mChiWat_flow_nominal,
    final m2_flow_nominal=mLoaCoo_flow_nominal,
    final dp1_nominal=0,
    dp2_nominal=200,
    final Q_flow_nominal=QCoo_flow_nominal,
    final T_a1_nominal=T_aChiWat_nominal,
    final T_a2_nominal=T_aLoaCoo_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
    annotation (Placement(transformation(extent={{0,4},{20,-16}})));
  Modelica.Blocks.Sources.RealExpression Q_flowCoo(y=hexCoo.Q2_flow)
    annotation (Placement(transformation(extent={{120,190},{140,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom2(k=max({
    mLoaHea_flow_nominal,mLoaCoo_flow_nominal}))
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conCoo(
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=true,
    yMin=0) "PI controller for cooling"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiCooFloNom(k=mChiWat_flow_nominal)
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  Utilities.Math.SmoothMax smoothMax(deltaX=1E-2) "C1 maximum"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
equation
  connect(hexCoo.port_b2, hexHea.port_a2)
    annotation (Line(points={{0,0},{-60,0}},     color={0,127,255}));
  connect(fan.port_b, hexCoo.port_a2)
    annotation (Line(points={{70,0},{20,0}}, color={0,127,255}));
  connect(gaiFloNom2.y, fan.m_flow_in)
    annotation (Line(points={{62,140},{80,140},{80,12}}, color={0,0,127}));
  connect(port_aChiWat, hexCoo.port_a1) annotation (Line(points={{-200,-180},{-20,
          -180},{-20,-12},{0,-12}}, color={0,127,255}));
  connect(hexCoo.port_b1, port_bChiWat) annotation (Line(points={{20,-12},{40,-12},
          {40,-180},{200,-180}}, color={0,127,255}));
  connect(port_aHeaWat, hexHea.port_a1) annotation (Line(points={{-200,-220},{
          -100,-220},{-100,-12},{-80,-12}},
                                       color={0,127,255}));
  connect(hexHea.port_b1, port_bHeaWat) annotation (Line(points={{-60,-12},{-40,
          -12},{-40,-220},{200,-220}}, color={0,127,255}));
  connect(conHea.y, gaiHeaFloNom.u)
    annotation (Line(points={{12,220},{38,220}}, color={0,0,127}));
  connect(conCoo.y, gaiCooFloNom.u)
    annotation (Line(points={{12,180},{38,180}}, color={0,0,127}));
  connect(gaiHeaFloNom.y,scaMasFloReqHeaWat.u)  annotation (Line(points={{62,220},
          {108,220},{108,100},{158,100}},      color={0,0,127}));
  connect(gaiCooFloNom.y, scaMasFloReqChiWat.u) annotation (Line(points={{62,180},
          {100,180},{100,80},{158,80}},      color={0,0,127}));
  connect(fan.P, scaPFan.u) annotation (Line(points={{69,9},{60,9},{60,-20},{
          140,-20},{140,140},{158,140}},
                     color={0,0,127}));
  connect(Q_flowHea.y, scaQActHea_flow.u) annotation (Line(points={{141,220},
          {150,220},{150,220},{158,220}}, color={0,0,127}));
  connect(Q_flowCoo.y, scaQActCoo_flow.u) annotation (Line(points={{141,200},
          {158,200},{158,200}}, color={0,0,127}));
  connect(TSetCoo, conCoo.u_s)
    annotation (Line(points={{-220,180},{-20,180},{-20,180},{-12,180}},
                                                    color={0,0,127}));
  connect(TSetHea, conHea.u_s)
    annotation (Line(points={{-220,220},{-60,220},{-60,220},{-12,220}},
                                                    color={0,0,127}));
  connect(smoothMax.y, gaiFloNom2.u)
    annotation (Line(points={{11,140},{38,140}}, color={0,0,127}));
  connect(conHea.y, smoothMax.u1) annotation (Line(points={{12,220},{20,220},{
          20,116},{-20,116},{-20,146},{-12,146}}, color={0,0,127}));
  connect(conCoo.y, smoothMax.u2) annotation (Line(points={{12,180},{16,180},{
          16,120},{-16,120},{-16,134},{-12,134}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-200,-240},{200,240}})));
end PartialFanCoil4Pipe;