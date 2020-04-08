require './config/environment'

use Rack::MethodOverride
use CommentsController
use ProblemsController
use SolutionsController
use UsersController
use FriendsController
run ApplicationController
