require_relative './config/environment'

use Rack::MethodOverride
use CommentsController
use ProblemsController
use SolutionsController
use UsersController
run ApplicationController
