xml.instruct!
xml.OpenSearchDescription('xmlns' => 'http://a9.com/-/spec/opensearch/1.1/', 'xmlns:moz' => 'http://www.mozilla.org/2006/browser/search/') do
  xml.ShortName SETTINGS['organization']['name']
  xml.Description "Search #{SETTINGS['organization']['name']}"
  xml.InputEncoding "UTF-8"
  # The sub call at the end of this line is because we want to use the rails URL helper, but don't want to urlencode the curly braces.
  xml.Url('type' => 'text/html', 'method' => 'get', 'template' => search_url(:query => "searchTerms").sub('searchTerms', '{searchTerms}') )
end
