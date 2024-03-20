# Nature Commitments


## Ruby version
2.6.3
## Node version 

## Quickstart

1. `bundle install`
2. `yarn install`
3. `bundle exec rails db:create db:migrate rails db:seed`
4. `bundle exec rails s` 
5. Obtain a copy of `config/master.key` from lastpass
6. Run `rake import:commitments`
7. On the Commitments page, you should see a list of commitments.

### Adding new commitments via csv
We are dependant on several fields on Commitment to filter the results we want to return over the API.

```scope :api_records, -> { where(state: 'live', cfn_approved: true, shareable: true) }```

We need to add these to any csv file for importing:
```
state, cfn_approved, shareable
live, true, true
live, true, true
```

### External API

We have an external API, that currently only includes a commitments index. The API only returns commitments created in Nature Commitments via the form or csv import, and which are published.

The API does not use authentication, but is rate limited to 25 requests per minute followed by a 10 minute ban. This is implemented on the server using Cloudflare, and not handled in the Rails app. 

[API Documentation](docs/external_api.md)
