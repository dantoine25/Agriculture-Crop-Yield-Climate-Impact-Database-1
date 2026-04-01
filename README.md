# Agriculture-Crop-Yield-Climate-Impact-Database-1 [ER.html](https://github.com/user-attachments/files/26420016/ER.html)

<div id="erd" style="padding:1rem 0"></div>
<script type="module">
import mermaid from 'https://esm.sh/mermaid@11/dist/mermaid.esm.min.mjs';
const dark = matchMedia('(prefers-color-scheme: dark)').matches;
await document.fonts.ready;
mermaid.initialize({
  startOnLoad: false,
  theme: 'base',
  fontFamily: '"Anthropic Sans", sans-serif',
  themeVariables: {
    darkMode: dark,
    fontSize: '13px',
    fontFamily: '"Anthropic Sans", sans-serif',
    lineColor: dark ? '#9c9a92' : '#73726c',
    textColor: dark ? '#c2c0b6' : '#3d3d3a',
    primaryColor: dark ? '#2e2c4a' : '#EEEDFE',
    primaryBorderColor: dark ? '#534AB7' : '#534AB7',
    primaryTextColor: dark ? '#c2c0b6' : '#26215C',
    secondaryColor: dark ? '#083328' : '#E1F5EE',
    secondaryBorderColor: dark ? '#0F6E56' : '#0F6E56',
    secondaryTextColor: dark ? '#c2c0b6' : '#04342C',
    tertiaryColor: dark ? '#2e1a10' : '#FAEEDA',
    tertiaryBorderColor: dark ? '#854F0B' : '#854F0B',
    tertiaryTextColor: dark ? '#c2c0b6' : '#412402',
  },
});
const diagram = `erDiagram
  Farmer {
    varchar FarmerID PK
    varchar FarmerName
    varchar PhoneNumber
    varchar Email
    varchar Address
    varchar NationalID
  }
  Farm {
    varchar FarmID PK
    varchar FarmName
    varchar Location
    decimal TotalAreaHa
    decimal CultivatedAreaHa
    boolean OrganicCertified
    varchar FarmerID FK
  }
  VarietyInfo {
    varchar VarietyName PK
    decimal TypicalYieldKgPerHa
    text ManagementNotes
  }
  GeneticVariety {
    varchar VarietyID PK
    varchar VarietyName FK
    varchar FarmID FK
  }
  Crop {
    varchar CropID PK
    varchar FarmID FK
    varchar CropName
    date PlantingDate
    date HarvestDate
    varchar GeneticVariety FK
    text ManagementNotes
  }
  YieldRecord {
    varchar YieldRecordID PK
    varchar FarmID FK
    varchar CropID FK
    decimal Yield
    text ManagementNotes
  }
  WeatherStation {
    varchar StationID PK
    decimal Latitude
    decimal Longitude
    decimal Elevation
  }
  ClimateObservation {
    varchar ObservationID PK
    varchar StationID FK
    datetime ObserveDate
    decimal TemperatureC
    decimal PrecipitationMm
    decimal SolarRadiation
    decimal IndPreseMMBs
    text Notes
  }
  SoilProfile {
    varchar SoilProfileID PK
    varchar StationID FK
    varchar FarmID FK
    decimal pH
    decimal OrganicMatterPct
    varchar Texture
    date LastSampleDate
  }

  Farmer ||--o{ Farm : "owns"
  Farm ||--o{ GeneticVariety : "hosts"
  VarietyInfo ||--o{ GeneticVariety : "defines"
  Farm ||--o{ Crop : "grows"
  VarietyInfo ||--o{ Crop : "variety"
  Crop ||--o{ YieldRecord : "recorded in"
  Farm ||--o{ YieldRecord : "belongs to"
  WeatherStation ||--o{ ClimateObservation : "captures"
  WeatherStation ||--|| SoilProfile : "linked to"
  Farm ||--|| SoilProfile : "has"
`;

const { svg } = await mermaid.render('erd-svg', diagram);
document.getElementById('erd').innerHTML = svg;

document.querySelectorAll('#erd svg .node').forEach(node => {
  const firstPath = node.querySelector('path[d]');
  if (!firstPath) return;
  const d = firstPath.getAttribute('d');
  const nums = d.match(/-?[\d.]+/g)?.map(Number);
  if (!nums || nums.length < 8) return;
  const xs = [nums[0], nums[2], nums[4], nums[6]];
  const ys = [nums[1], nums[3], nums[5], nums[7]];
  const x = Math.min(...xs), y = Math.min(...ys);
  const w = Math.max(...xs) - x, h = Math.max(...ys) - y;
  const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
  rect.setAttribute('x', x); rect.setAttribute('y', y);
  rect.setAttribute('width', w); rect.setAttribute('height', h);
  rect.setAttribute('rx', '8');
  for (const a of ['fill', 'stroke', 'stroke-width', 'class', 'style']) {
    if (firstPath.hasAttribute(a)) rect.setAttribute(a, firstPath.getAttribute(a));
  }
  firstPath.replaceWith(rect);
});

document.querySelectorAll('#erd svg .row-rect-odd path, #erd svg .row-rect-even path').forEach(p => {
  p.setAttribute('stroke', 'none');
});
</script>
