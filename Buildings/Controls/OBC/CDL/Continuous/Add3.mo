within Buildings.Controls.OBC.CDL.Continuous;
block Add3 "Output the sum of the three inputs"

  parameter Real k1=+1 "Gain of upper input";

  parameter Real k2=+1 "Gain of middle input";

  parameter Real k3=+1 "Gain of lower input";

  Interfaces.RealInput u1 "Connector 1 of Real input signals"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Interfaces.RealInput u2 "Connector 2 of Real input signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealInput u3 "Connector 3 of Real input signals"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Interfaces.RealOutput y "Connector of Real output signals"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = k1*u1 + k2*u2 + k3*u3;

annotation (
defaultComponentName="add3",
Documentation(info="<html>
<p>
Block that outputs <code>y</code> as the weighted <i>sum</i> of the
three input signals <code>u1</code>, <code>u2</code> and <code>u3</code>,
</p>
<pre>
  y = k1*u1 + k2*u2 + k3*u3;
</pre>
<p>
where <code>k1</code>, <code>k2</code> and <code>k3</code> are parameters.
</p>

</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={          Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,50},{5,90}},
          lineColor={0,0,0},
          textString="%k1"),
        Text(
          extent={{-100,-20},{5,20}},
          lineColor={0,0,0},
          textString="%k2"),
        Text(
          extent={{-100,-50},{5,-90}},
          lineColor={0,0,0},
          textString="%k3"),
        Text(
          extent={{2,36},{100,-44}},
          lineColor={0,0,0},
          textString="+")}));
end Add3;
