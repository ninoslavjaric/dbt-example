# Sample DBT Project README

## Overview

This README outlines the structure and workflow of a sample DBT (Data Build Tool) project designed to manage meta tables for pipeline behavior determination. The project comprises models representing two layers: staging (stg) and marts (marts). Additionally, macros are implemented to provide generic solutions, simplifying the addition of multiple models.

## Project Structure

- **Seeds:**
  - `seeds/mapping_rules.csv`: Placeholder CSV seed emulating meta tables for mapping rules.
  - `seeds/unpivot_rules.csv`: Placeholder CSV seed emulating meta tables for unpivot rules.

- **Models:**
  - `models/example/stg/stg_sample.sql`: Example staging model.
  - `models/example/marts/mart_sample.sql`: Example marts model.

- **Macros:**
  - `macros/stager.sql`: Macro designed for staging layer models.
  - `macros/transformer.sql`: Macro designed for marts layer models.

## Development Process

The development process revolves around the usage of `mapping_rules.csv` and `unpivot_rules.csv` seeds, which simulate meta tables alongside production seeds for testing and development purposes. These seeds mirror the structure of actual meta tables and facilitate iterative development.

The `sample.sql` model serves as a template, demonstrating the structure of both staging and marts models. Each model within the `example` directory is associated with a macro call, enabling a generic solution approach.

## How to Use

1. Configure your DBT environment appropriately.
2. Adapt and refine the seeds (`mapping_rules.csv` and `unpivot_rules.csv`) to align with the structure of your meta tables.
3. Customize the example models (`stg_sample.sql` and `mart_sample.sql`) according to your specific requirements, or introduce new models as necessary.
4. Employ the macros (`stager.sql` and `transformer.sql`) to expedite the development of new models by providing the requisite parameters.

## Note

This README serves as an illustrative example of how to address the challenge of managing meta tables and orchestrating pipelines within a DBT project. Actual project configurations and implementations may diverge based on unique needs and preferences.

## License

This project is licensed under the [MIT License](LICENSE).
