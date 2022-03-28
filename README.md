# Commitments for Nature


## Ruby version
2.6.3
## Node version 

## Quickstart

1. `bundle install`
2. `yarn install`
3. `bundle exec rails db:create db:migrate rails db:seed`
4. `bundle exec rails s` 
5. Obtain a copy of the 'commitments' CSV if not already present in `lib/data/seeds`
6. Run `rake import_commitments_and_migrate_data`
7. On the Commitments page, you should see a list of commitments.