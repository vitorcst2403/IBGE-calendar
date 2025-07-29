# IBGE Calendar Generator
This project automates the creation of `.ics` calendar files for scheduled releases of statistical products published by IBGE (Instituto Brasileiro de Geografia e Estatística). It fetches release dates from the IBGE API and generates calendar files that can be imported into Google Calendar, Outlook, or any other calendar application.

## Project Structure
```plaintext
├── output/                  # Folder containing generated .ics calendar files
├── renv/                    # R environment for reproducibility
├── renv.lock                # Lockfile for package versions
├── gen_calendar.R           # Main script to fetch data and generate calendars
└── README.md                # Project documentation
```

##  Features
- Fetches metadata for all IBGE statistical products
- Retrieves release schedules via the IBGE calendar API
- Generates `.ics` calendar files with:
    - Proper UTF-8 encoding
    - Timezone-aware timestamps (America/Sao_Paulo)
    - 9:00 AM scheduled events
- Fully reproducible with `renv`

## Requirements
- R (≥ 4.0)
- Packages:
  - httr
  - jsonlite
  - lubridate
  - here
  - purrr
  - renv (for environment management)

## Usage
1. Clone the repository:
```Shell
git clone https://github.com/your-username/ibge-calendar-generator.git
cd ibge-calendar-generator
```

2. Open `gen_calendar.R` in RStudio or run it via terminal:
```R
source(gen_calendar.R)
```
3. Find the generated `.ics` files in the `output/` folder.

## Example Output
Each `.ics` file corresponds to a statistical product (e.g., IPCA, PNAD Contínua) and contains all scheduled release dates as calendar events.

## Author
Vitor Chagas da Costa

Feel free to reach out or open an issue if you have questions or suggestions!
