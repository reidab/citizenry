# Hey Sorty

Developed for use on [Purify: Awesome Bug & Issue Tracking][1], Hey Sorty gives you simple column sorting for your Rails apps.

## Installation

Install as a plugin:

    script/plugin install git@github.com:purify/hey_sorty.git

## Usage

This branch is for use with Rails 3 - if you have a Rails 2.3 app, please look at the 2.3 branch.

Add sorty to your model:

    class MyModel < ActiveRecord::Base
      sortable
    end

You can optionally specify the default column to sort on, and the default order in which to sort (defaults to id asc):

    class MyModel < ActiveRecord::Base
      sortable :updated_at, :desc
    end

Next, add sorty to your controller:

    class MyModelController < ApplicationController
      def index
        @my_models = MyModel.sorty(params).paginate(:per_page => 20, :page => params[:page])
      end
    end

Finally, add the sortable links to your view:

    <table>
      <thead>
        <tr>
          <th class="name"><%= sorty(:name, :label => 'Full Name') %></th>
          <th class="created_at"><%= sorty(:created_at, :label => 'Date') %></th>
          <th class="description"><%= sorty(:description) %></th>
        </tr>
      </thead>
      <tbody>
        <%= render @my_models %>
      </tbody>
    </table>
    <%= will_paginate @my_models %>


## Contributors

* [Jim Neath][2]
* [Matt Hall][3]

## License

License

(The MIT License)

Copyright &copy; 2009-2010

* [Jim Neath][2]

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[1]:http://purifyapp.com
[2]:http://jimneath.org
[3]:http://codebeef.com