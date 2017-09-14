within Buildings.Controls.OBC.ASHRAE.G36.Atomic.Validation;
model SystemRequestsReheatBox
  "Validate model of generating system requests"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.G36.Atomic.SystemRequestsReheatBox
    sysReq_RehBox(have_boiPla=true)
    "Block outputs system requests"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.Sine sine(freqHz=1/7200, offset=296.15)
    "Generate data for setpoint"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TCooSet(samplePeriod=1800)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Modelica.Blocks.Sources.Sine TRoo(
    freqHz=1/7200,
    amplitude=2,
    offset=299.15) "Zone temperature"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    height=0.9,
    duration=7200,
    offset=0.1) "Cooling loop signal"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirSet(
    height=0.9,
    duration=7200,
    offset=0.1) "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirRate(
    duration=7200,
    offset=0.1,
    height=0.3) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp damPos(
    duration=7200,
    height=0.7,
    offset=0.3) "Damper position"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.Sine sine1(
    freqHz=1/7200,
    offset=305.15)
    "Generate data for setpoint"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TDisAirSet(
    samplePeriod=1800)
    "Discharge air setpoint temperature"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Modelica.Blocks.Sources.Sine TDisAir(
    freqHz=1/7200,
    amplitude=2,
    offset=293.15)
    "Discharge air temperature"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp valPos(
    duration=7200,
    height=1,
    offset=0)
    "Hot water valve position"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

equation
  connect(sine.y, TCooSet.u)
    annotation (Line(points={{-39,90},{-22,90}}, color={0,0,127}));
  connect(TCooSet.y, sysReq_RehBox.TCooSet)
    annotation (Line(points={{1,90},{46,90},{46,79},{59,79}},
      color={0,0,127}));
  connect(TRoo.y, sysReq_RehBox.TRoo)
    annotation (Line(points={{-39,60},{16,60},{16,77},{59,77}},
      color={0,0,127}));
  connect(uCoo.y, sysReq_RehBox.uCoo)
    annotation (Line(points={{1,40},{18,40},{18,75},{59,75}},
      color={0,0,127}));
  connect(disAirSet.y, sysReq_RehBox.VDisAirSet)
    annotation (Line(points={{-39,20},{20,20},{20,72},{59,72}},
      color={0,0,127}));
  connect(disAirRate.y, sysReq_RehBox.VDisAir)
    annotation (Line(points={{1,0},{22,0},{22,70},{59,70}},
      color={0,0,127}));
  connect(damPos.y, sysReq_RehBox.uDam)
    annotation (Line(points={{-39,-20},{24,-20},{24,68},{59,68}},
      color={0,0,127}));
  connect(sine1.y, TDisAirSet.u)
    annotation (Line(points={{-69,-40},{-22,-40}}, color={0,0,127}));
  connect(TDisAirSet.y, sysReq_RehBox.TDisAirSet)
    annotation (Line(points={{1,-40},{26,-40},{26,65},{59,65}},
      color={0,0,127}));
  connect(TDisAir.y, sysReq_RehBox.TDisAir)
    annotation (Line(points={{-39,-60},{28,-60},{28,63},{59,63}},
      color={0,0,127}));
  connect(valPos.y, sysReq_RehBox.uHotVal)
    annotation (Line(points={{1,-80},{30,-80},{30,61},{59,61}},
      color={0,0,127}));

annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Atomic/Validation/SystemRequestsReheatBox.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Atomic.SystemRequestsReheatBox\">
Buildings.Controls.OBC.ASHRAE.G36.Atomic.SystemRequestsReheatBox</a>
for generating system requests.
</p>
</html>", revisions="<html>
<ul>
<li>
September 13, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}})));
end SystemRequestsReheatBox;
