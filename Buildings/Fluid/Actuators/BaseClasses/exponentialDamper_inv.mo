within Buildings.Fluid.Actuators.BaseClasses;
function exponentialDamper_inv
  "Inverse function of damper opening characteristics for an exponential damper"
  import Modelica.Math.Matrices;
  extends Modelica.Icons.Function;
  input Real kThetaSqRt(min=0);
  input Real a(unit="") "Coefficient a for damper characteristics";
  input Real b(unit="") "Coefficient b for damper characteristics";
  input Real[3] cL "Polynomial coefficients for curve fit for y < yl";
  input Real[3] cU "Polynomial coefficients for curve fit for y > yu";
  input Real yL "Lower value for damper curve";
  input Real yU "Upper value for damper curve";
  // output Real y(min=0, max=1, unit="");
  output Real y;
  output Real y1;
  output Real y2;
  output Real flag;
protected
  Real roots[2,2] = fill(0, 2, 2);
  Real yC(min=0, max=1, unit="")
    "y constrained to 0 <= y <= 1 to avoid numerical problems";
  Real kL = Buildings.Fluid.Actuators.BaseClasses.exponentialDamper(
       y=yL, a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU);
  Real kU = Buildings.Fluid.Actuators.BaseClasses.exponentialDamper(
       y=yU, a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU);
  Real delta;
algorithm
  if kThetaSqRt > kL then
    // kThetaSqRt := sqrt(Modelica.Math.exp(cL[3] + yC * (cL[2] + yC * cL[1])));
    delta := cL[2]^2 - 4 * cL[1] * (-2 * Modelica.Math.log(kThetaSqRt) + cL[3]);
    y1 := (-cL[2] - sqrt(delta)) / (2 * cL[1]);
    y2 := (-cL[2] + sqrt(delta)) / (2 * cL[1]);
    y := if cL[2] + 2 * cL[1] * y1 <= 0 then max(0, y1) else max(0, y2);
    flag := 1;
  else
    if kThetaSqRt < kU then
    //kThetaSqRt := sqrt(Modelica.Math.exp(cU[3] + yC * (cU[2] + yC * cU[1])));
      delta := cU[2]^2 - 4 * cU[1] * (-2 * Modelica.Math.log(kThetaSqRt) + cU[3]);
      y1 := (-cU[2] - sqrt(delta)) / (2 * cU[1]);
      y2 := (-cU[2] + sqrt(delta)) / (2 * cU[1]);
      y := if cU[2] + 2 * cU[1] * y1 <= 0 then min(1, y1) else min(1, y2);
      flag := -1;
    else
      y := 1 -(2 * Modelica.Math.log(kThetaSqRt) - a) / b;
      y1 := 0;
      y2 := 0;
      flag := 0;
      //kThetaSqRt := sqrt(Modelica.Math.exp(a+b*(1-y))) "y=0 is closed";
    end if;
  end if;
annotation (
Documentation(info="<html>
<p>
This function computes the opening characteristics of an exponential damper.
</p><p>
The function is used by the model
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.Exponential\">
Buildings.Fluid.Actuators.Dampers.Exponential</a>.
</p><p>
For <code>yL &lt; y &lt; yU</code>, the damper characteristics is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k<sub>d</sub>(y) = exp(a+b (1-y)).
</p>
<p>
Outside this range, the damper characteristic is defined by a quadratic polynomial.
</p>
<p>
Note that this implementation returns <i>sqrt(k<sub>d</sub>(y))</i> instead of <i>k<sub>d</sub>(y)</i>.
This is done for numerical reason since otherwise <i>k<sub>d</sub>(y)</i> may be an iteration
variable, which may cause a lot of warnings and slower convergence if the solver
attempts <i>k<sub>d</sub>(y) &lt; 0</i> during the iterative solution procedure.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2014 by Michael Wetter:<br/>
Improved documentation.
</li>
<li>
July 1, 2011 by Michael Wetter:<br/>
Added constraint to control input to avoid using a number outside
<code>0</code> and <code>1</code> in case that the control input
has a numerical integration error.
</li>
<li>
April 4, 2010 by Michael Wetter:<br/>
Reformulated implementation. The new implementation computes
<code>sqrt(kTheta)</code>. This avoid having <code>kTheta</code> in
the iteration variables, which caused warnings when the solver attempted
<code>kTheta &lt; 0</code>.
</li>
<li>
June 22, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),   smoothOrder=1);
end exponentialDamper_inv;
