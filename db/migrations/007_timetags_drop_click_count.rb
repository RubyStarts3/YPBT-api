# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    alter_table(:timetags) do
      drop_column :click_count
    end
  end

  down do
    alter_table(:timetags) do
      add_column :click_count, Integer
    end
  end
end
