within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl;
block TemperatureSetpointControl "Single temperature setpoint"

  parameter Real delTSetShe=1
    "Temperature setpoint change amount for the load-shed mode";

  parameter Real delTSetReb=-1
    "Temperature setpoint change amount for the load-rebound mode";

  parameter Real delTSetSheTho(min=0)=0.5
    "Threshold of zone temperature setpoint difference below which the zone temperature setpoint change for the load-shed mode is activated. This is an absolute value, so it is always positive";

  parameter Real samPerPre(unit="s")=300
    "Sample period for the pre-cool or pre-heat mode";
  parameter Real samPerBas(unit="s")=300
    "Sample period for the baseline mode";
  parameter Real samPerShe(unit="s")=300
    "Sample period for the load-shed mode";
  parameter Real samPerReb(unit="s")=300
    "Sample period for the load-rebound mode";
  parameter Boolean setMod=true
    "Type of setpoint. True for heating, false for cooling";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCur "current zone temperature"
    annotation (Placement(transformation(extent={{-190,-12},{-150,28}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTarPreSet "setpoint target for precool or preheat"
    annotation (Placement(transformation(extent={{-192,-106},{-152,-66}}),
        iconTransformation(extent={{-192,-106},{-152,-66}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDefSet "Default setpoint"
    annotation (Placement(transformation(extent={{-192,-204},{-152,-164}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCurSet "current setpoint"
    annotation (Placement(transformation(extent={{-190,-54},{-150,-14}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTarSheSet "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-192,-156},{-152,-116}}),
        iconTransformation(extent={{-192,-156},{-152,-116}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna "have priority"
    annotation (Placement(transformation(extent={{-190,60},{-150,100}}),
        iconTransformation(extent={{-190,60},{-150,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal; -1 = precool or preheat; 1 = ratchet; 2 = rebound"
    annotation (Placement(transformation(extent={{-190,24},{-150,64}}),
        iconTransformation(extent={{-190,24},{-150,64}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TComSet "setpoint command"
    annotation (Placement(transformation(extent={{250,-90},{290,-50}}),
        iconTransformation(extent={{250,-90},{290,-50}})));
  Generic.MultipleStepSetpointChange setShe
    annotation (Placement(transformation(extent={{162,-34},{182,-14}})));
  Generic.MultipleStepSetpointChange setReb
    annotation (Placement(transformation(extent={{158,-142},{178,-122}})));
  Generic.SingleStepSetpointChange                                          setPre
    annotation (Placement(transformation(extent={{160,74},{180,94}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.Subsequences.ModeSelection
    modeSelection
    annotation (Placement(transformation(extent={{216,-78},{236,-58}})));

equation
  connect(uMod, modeSelection.uMod) annotation (Line(points={{-170,44},{-24,44},
          {-24,50},{86,50},{86,-60.6667},{214.261,-60.6667}}, color={255,127,0}));
  connect(modeSelection.y,TComSet)  annotation (Line(points={{237.739,-68},{244,
          -68},{244,-70},{270,-70}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-150,-200},{250,120}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-150,-200},{250,120}},
        grid={2,2})),
    Documentation(info="<html>
<p>This is a sequence that brings the full suite of control for a single zone temperature setpoint. It can be either a heating zone temperature setpoint or a cooling zone temperature setpoint. </p>
<p>The demand flexibility mode of the system, represented by the input variable <code>uMod</code>, include the pre-cool/pre-heat mode (<code>uMod</code> = -1), the baseline mode (<code>uMod</code> = 0), the load-shed mode (<code>uMod</code> = 1), and the load-rebound mode (<code>uMod</code> = 2).</p>
<p>The <code>have_pri</code> boolean input variable specifies whether the setpoint change operation will be executed or not. This is useful in multiple-zone or multiple-equipment scenarios where there is a need to prioritize which zone or equipment will go through the setpoint change. </p>
<p>If <code>has_pri</code> = <code>false</code>, the output variable <code>TSetCom</code> will take the value of the input variable <code>TSetCur</code>.</p>
<p>If <code>has_pri</code> = <code>true</code> and <code>uMod</code> = -1, the output variable <code>TSetCom</code> will take the value of the input variable <code>TSetTarPre</code>. This operation is executed every <code>samPerPre</code> seconds.</p>
<p>If <code>has_pri</code> = <code>true</code> and <code>uMod</code> = 0, the output variable <code>TSetCom</code> will take the value of the input variable <code>TSetBas</code>. This operation is executed every <code>samPerBas</code> seconds.</p>
<p>If <code>has_pri</code> = <code>true</code> and <code>uMod</code> = 1, there are specific elements in this sequence that checks whether a zone&apos;s actual zone temperature difference has reached a zone temperature difference threshold (<code>delTSetSheTho</code>) for changing zone setpoints. On one hand, the threshold <code>delTSetSheTho</code> always takes positive values. On the other hand, a zone&apos;s actual zone temperature difference is defined as the current zone temperature minus the current zone temperature heating or cooling setpoint. </p>
<p>For heating mode and the heating setpoint, if the actual zone temperature difference is less than the threshold <code>delTSetSheTho</code>, the condition to perform load-shed operation will be met. For cooling mode and the cooling setpoint, if the actual zone temperature difference is more than the negative of the threshold <code>delTSetSheTho</code>, the condition to perform load-shed operation will be met. </p>
<p>If the condition to perform load-shed operation is met, the output variable <code>TSetCom</code> will take the value <code>TSetCur + delTSetShe</code>, limited by the range between the input variable <code>TSetBas</code> and the input variable <code>TSetTarShe</code>. If the condition to perform load-shed operation is not met, the output variable <code>TSetCom</code> will take the value <code>TSetCur</code>. This operation is executed every <code>samPerShe</code> seconds.</p>
<p>If <code>has_pri </code> = <code>true</code> and <code>uMod</code> = 2, the output variable <code>TSetCom</code> will take the value <code>TSetCur + delTSetReb</code>, limited by the range between the input variable <code>TSetBas</code> and the input variable <code>TSetTarShe</code>. This operation is executed every <code>samPerReb</code> seconds.</p>
<p><br>Output variables also include boolean flags that specify whether the current setpoint has reached the baseline setpoint <code>reach_TSetBas</code> or the target setpoints <code>reach_TSetTarShe</code> and <code>reach_TSetTarReb</code>. </p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end TemperatureSetpointControl;
