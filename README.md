# Tax Website

Created to calculate UK taxes and determine the optimum SIPP contributions.

Intended to be run locally in the development environment only.

Does not support all parts of tax calculations in older tax years.

## Install

* Standard Ruby on Rails application
  * Install dependencies with `bundle install` and `yarn`
* Create a PostgreSQL database (setting `PGDATABASE`, etc. if required)
* Run `bin/setup` or perform the following steps:
  * Generate a production `secret_key_base` by running `rails credentials:edit`
  * Create the database tables by running `rails db:prepare`

## Copyright

    Copyright 2021  Simon Arlott

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
