within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.Validation;
model SingleTemperatureSetpoint "Single temperature setpoint"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.TemperatureSetpointControl
    singleTemperatureSetpoint
    annotation (Placement(transformation(extent={{-50,-6},{-10,26}})));
  annotation (Documentation(info="<html>
<p>This example validates <a href=\"modelica://cdl_models.Move.ZoneSetpointControl.SingleTemperatureSetpoint\">
Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.SingleTemperatureSetpoint</a>.</p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end SingleTemperatureSetpoint;
