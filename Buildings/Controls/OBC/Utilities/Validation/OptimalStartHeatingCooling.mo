within Buildings.Controls.OBC.Utilities.Validation;
model OptimalStartHeatingCooling
  "Validation model for the block OptimalStart for both heating and cooling system"

  Buildings.Controls.OBC.Utilities.OptimalStart optSta(computeHeating=false,
      computeCooling=false) "Optimal start for both heating and cooling system"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=0.0000004, y_start=19 + 273.15)
    "Integrate temperature derivative with k indicating the inverse of zone thermal capacitance"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetCooOcc(k=24 + 273.15)
    "Zone cooling setpoint during occupancy"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOutHea(
    amplitude=5,
    freqHz=1/86400,
    offset=15 + 273.15,
    startTime(displayUnit="h") = 0)
    "Outdoor dry bulb temperature to test heating"
    annotation (Placement(transformation(extent={{-208,-20},{-188,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain UA(k=25)
    "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dT(k1=-1)
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain QCoo(k=-4000)
    "Heat extraction in the zone"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain TSetUp(k=-6)
    "Cooling setpoint temperature setup during unoccupied period"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetCoo(
    table=[0,30 + 273.15; 7*3600,24 + 273.15; 19*3600,30 + 273.15; 24*3600,30
         + 273.15],
    y(unit="K"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Reset temperature from unoccupied to occupied for optimal start period"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID1(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=3,
    yMax=1,
    yMin=0,
    reverseAction=true) "PI control for space cooling"
    annotation (Placement(transformation(extent={{180,0},{200,20}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{7,19},period=24*3600)
    "Daily schedule"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=3)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaOcc(k=21+273.15)
    "Zone heating setpoint during occupancy"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain TSetBac(k=6)
    "Heating setpoint temperature set back during unoccupied period"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Reset temperature from unoccupied to occupied for optimal start period"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=1,
    yMax=1,
    yMin=0) "PI control for space heating"
    annotation (Placement(transformation(extent={{180,40},{200,60}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetHea(
    table=[0,15 + 273.15; 7*3600,21 + 273.15; 19*3600,15 + 273.15; 24*3600,15
         + 273.15],
    y(unit="K"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain QHea(k=2000)
    "Heat injection in the zone"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add TOutCoo
    "Outdoor dry bulb temperature to test cooling"
    annotation (Placement(transformation(extent={{-170,-40},{-150,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=15,
    duration=86400,
    startTime(displayUnit="d") = 777600) "Add temperature ramp"
    annotation (Placement(transformation(extent={{-208,-60},{-188,-40}})));
equation
  connect(dT.y, UA.u)   annotation (Line(points={{-118,10},{-102,10}}, color={0,0,127}));
  connect(integrator.y, optSta.TZon) annotation (Line(points={{1,10},{10,10},{10,
          7},{18,7}},      color={0,0,127}));
  connect(integrator.y, dT.u1) annotation (Line(points={{1,10},{6,10},{6,34},{
          -146,34},{-146,16},{-142,16}},          color={0,0,127}));
  connect(TSetCooOcc.y, optSta.TSetZonCoo) annotation (Line(points={{2,70},{10,70},
          {10,13},{18,13}},      color={0,0,127}));
  connect(optSta.optOn, booToRea1.u) annotation (Line(points={{42,6},{50,6},{50,
          10},{58,10}}, color={255,0,255}));
  connect(booToRea1.y, TSetUp.u)   annotation (Line(points={{82,10},{98,10}},   color={0,0,127}));
  connect(TSetUp.y, add1.u1) annotation (Line(points={{122,10},{132,10},{132,16},
          {138,16}},  color={0,0,127}));
  connect(TSetCoo.y[1], add1.u2) annotation (Line(points={{121,-50},{134,-50},{134,
          4},{138,4}},     color={0,0,127}));
  connect(add1.y, conPID1.u_s)   annotation (Line(points={{162,10},{178,10}},   color={0,0,127}));
  connect(integrator.y, conPID1.u_m) annotation (Line(points={{1,10},{6,10},{6,
          -20},{190,-20},{190,-2}},           color={0,0,127}));
  connect(occSch.tNexOcc, optSta.tNexOcc) annotation (Line(points={{1,-44},{10,-44},
          {10,2},{18,2}},       color={0,0,127}));
  connect(UA.y, mulSum.u[1]) annotation (Line(points={{-78,10},{-70,10},{-70,
          11.3333},{-62,11.3333}},
                          color={0,0,127}));
  connect(integrator.u, mulSum.y)    annotation (Line(points={{-22,10},{-38,10}}, color={0,0,127}));
  connect(TSetHeaOcc.y, optSta.TSetZonHea) annotation (Line(points={{2,110},{14,
          110},{14,18},{18,18}}, color={0,0,127}));
  connect(optSta.optOn, booToRea2.u) annotation (Line(points={{42,6},{50,6},{50,
          50},{58,50}}, color={255,0,255}));
  connect(booToRea2.y, TSetBac.u)   annotation (Line(points={{82,50},{98,50}}, color={0,0,127}));
  connect(TSetHea.y[1], add2.u1) annotation (Line(points={{121,90},{130,90},{130,
          56},{138,56}},     color={0,0,127}));
  connect(TSetBac.y, add2.u2) annotation (Line(points={{122,50},{128,50},{128,44},
          {138,44}}, color={0,0,127}));
  connect(add2.y, conPID.u_s)   annotation (Line(points={{162,50},{178,50}}, color={0,0,127}));
  connect(conPID.u_m, dT.u1) annotation (Line(points={{190,38},{190,34},{-146,34},
          {-146,16},{-142,16}}, color={0,0,127}));
  connect(conPID1.y, QCoo.u) annotation (Line(points={{202,10},{210,10},{210,-64},
          {-110,-64},{-110,-30},{-102,-30}}, color={0,0,127}));
  connect(conPID.y, QHea.u) annotation (Line(points={{202,50},{212,50},{212,-108},
          {-108,-108},{-108,-90},{-102,-90}}, color={0,0,127}));
  connect(QCoo.y, mulSum.u[2]) annotation (Line(points={{-78,-30},{-70,-30},{-70,
          10},{-62,10}}, color={0,0,127}));
  connect(QHea.y, mulSum.u[3]) annotation (Line(points={{-78,-90},{-68,-90},{-68,
          8.66667},{-62,8.66667}}, color={0,0,127}));
  connect(TOutHea.y, TOutCoo.u1) annotation (Line(points={{-186,-10},{-178,-10},
          {-178,-24},{-172,-24}}, color={0,0,127}));
  connect(TOutCoo.y, dT.u2) annotation (Line(points={{-148,-30},{-146,-30},{-146,
          4},{-142,4}}, color={0,0,127}));
  connect(ram.y, TOutCoo.u2) annotation (Line(points={{-186,-50},{-178,-50},{-178,
          -36},{-172,-36}}, color={0,0,127}));
  annotation (
  experiment(
      StopTime=864000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),__Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/Validation/OptimalStartHeatingCooling.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This models validates both space heating and cooling for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a>.
</p>
<p>
The first ten days is to test the heating case with a lower outdoor temperature. 
The next ten days has a higher outdoor temprature, which is to test the cooling case.
The zone model has a time constant of 27.8 hours. The optimal start block converges separately
to an optimal start time for heating and cooling. Note that on the 11th day, the zone
temperature is in the deadband, so there is no need to optimally start the heating or
cooling system in advance.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 15, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,160}})));
end OptimalStartHeatingCooling;