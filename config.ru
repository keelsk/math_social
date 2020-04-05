require_relative './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride
use CommentsController
use ProblemsController
use SolutionsController
use UsersController
run ApplicationController
