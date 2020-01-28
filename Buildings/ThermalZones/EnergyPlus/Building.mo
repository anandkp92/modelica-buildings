within Buildings.ThermalZones.EnergyPlus;
model Building
  "Model that declares a building to which thermal zones belong to"
  extends Modelica.Blocks.Icons.Block;

  final constant String modelicaNameBuilding = getInstanceName()
    "Name of this instance"
    annotation(HideResult=true);

  parameter String idfName "Name of the IDF file"
    annotation(Evaluate=true);
  parameter String weaName "Name of the EnergyPlus weather file (mos file)"
    annotation(Evaluate=true);

  parameter Boolean usePrecompiledFMU = false
    "Set to true to use pre-compiled FMU with name specified by fmuName"
    annotation(Dialog(tab="Debug"));

  parameter String fmuName=""
    "Specify if a pre-compiled FMU should be used instead of EnergyPlus (mainly for development)"
    annotation(Dialog(tab="Debug", enable=usePrecompiledFMU));

  parameter Buildings.ThermalZones.EnergyPlus.Types.Verbosity verbosity=
    Buildings.ThermalZones.EnergyPlus.Types.Verbosity.Debug
    "Verbosity of EnergyPlus output"
    annotation(Dialog(tab="Debug"));

  parameter Boolean showWeatherData = true
    "Set to true to enable a connector with the weather data"
    annotation(Dialog(tab="Advanced"));
  parameter Boolean computeWetBulbTemperature=true
    "If true, then this model computes the wet bulb temperature"
    annotation(Dialog(tab="Advanced", enable=showWeatherData));

  parameter Boolean printUnits = true "Set to true to print units of OutputVariable instances to log file"
    annotation(Dialog(group="Diagnostics"));

  BoundaryConditions.WeatherData.Bus weaBus if
        showWeatherData "Weather data bus"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  final parameter String epWeaName=
      Modelica.Utilities.Strings.replace(
          string=weaName,
          searchString=".mos",
          replaceString=".epw",
          startIndex=weaStrLen-4,
          replaceAll=false,
          caseSensitive=true)
      "EnergyPlus weather data file name (with epw extension)"
      annotation(Evaluate=true);

protected
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final filNam = weaName,
    final computeWetBulbTemperature=computeWetBulbTemperature) if
       showWeatherData
      "Weather data reader"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Integer weaStrLen = Modelica.Utilities.Strings.length(weaName)
    "Length of weather data file";
  parameter String weaFilExt = Modelica.Utilities.Strings.substring(string=weaName, startIndex=weaStrLen-3, endIndex=weaStrLen)
    "Extension of weather data file";
  Boolean weaFilEndsInEpw = Modelica.Utilities.Strings.isEqual(".epw", weaFilExt)
    "Flag, true if weaName ends in .epw";
initial equation
  if  weaFilEndsInEpw then
    Modelica.Utilities.Streams.error(
      "Received 'weaName = " + weaName + "' in '" + modelicaNameBuilding
      + "'.\nWeather data file must end in '.mos'.\nModelica will rename the file to '.epw' when it calls EnergyPlus.");
  else
    assert(Modelica.Utilities.Strings.isEqual(".mos", weaFilExt),
      "Weather data file in '" + modelicaNameBuilding + "' must end in '.mos', received '" + weaName + "'.");
  end if;
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{10,0},{100,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
annotation (
  defaultComponentName="building",
  defaultComponentPrefixes="inner",
  missingInnerMessage="
Your model is using an outer \"building\" component to declare building-level parameters, but
an inner \"building\" component is not defined.
Drag one instance of Buildings.ThermalZones.EnergyPlus.Building into your model,
above all declarations of Buildings.ThermalZones.EnergyPlus.ThermalZone,
to specify building-level parameters.",
  Icon(graphics={
          Bitmap(extent={{-44,-144},{94,-6}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/spawn_icon_darkbluetxmedres.png",
          visible=not usePrecompiledFMU),
      Rectangle(
        extent={{-64,54},{64,-48}},
        lineColor={150,150,150},
        fillPattern=FillPattern.Solid,
        fillColor={150,150,150}),
      Polygon(
        points={{0,96},{-78,54},{80,54},{0,96}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
        extent={{16,12},{44,40}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-42,12},{-14,40}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-42,-32},{-14,-4}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-32},{44,-4}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}));
end Building;