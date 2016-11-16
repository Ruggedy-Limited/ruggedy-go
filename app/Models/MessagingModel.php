<?php

namespace App\Models;

use App\Commands\Command;
use App\Commands\CreateWorkspace;
use App\Commands\DeleteAsset;
use App\Commands\DeleteWorkspace;
use App\Commands\EditAsset;
use App\Commands\EditUserAccount;
use App\Commands\EditWorkspace;
use App\Commands\GetAssetsInWorkspace;
use App\Commands\GetAssetsMasterList;
use App\Commands\GetListOfAppsInWorkspace;
use App\Commands\GetListOfPermissions;
use App\Commands\GetListOfUsersInTeam;
use App\Commands\GetListOfUsersWorkspaces;
use App\Commands\GetUserInformation;
use App\Commands\GetWorkspace;
use App\Commands\RevokePermission;
use App\Commands\UpsertPermission;
use App\Exceptions\ActionNotPermittedException;
use App\Exceptions\AssetNotFoundException;
use App\Exceptions\ComponentNotFoundException;
use App\Exceptions\InvalidEmailException;
use App\Exceptions\InvalidInputException;
use App\Exceptions\InvalidPermissionException;
use App\Exceptions\TeamNotFoundException;
use App\Exceptions\UserNotFoundException;
use App\Exceptions\UserNotInTeamException;
use App\Exceptions\WorkspaceNotFoundException;
use Doctrine\ORM\ORMException;
use Illuminate\Support\Collection;
use Exception;


class MessagingModel
{
    /** API General */
    const ERROR_DEFAULT       = "error_default";
    const ERROR_INVALID_INPUT = "error_invalid_input";
    const ERROR_INVALID_EMAIL = "error_sending_invite_invalid_email";

    /** API User Management */
    const ERROR_SENDING_INVITE_GENERAL            = "error_sending_invite";
    const ERROR_TEAM_DOES_NOT_EXIST               = "error_team_does_not_exist";
    const ERROR_TEAM_MEMBER_DOES_NOT_EXIST        = "error_team_member_does_not_exist";
    const ERROR_USER_DOES_NOT_EXIST               = "error_user_does_not_exist";
    const ERROR_USER_NOT_TEAM_OWNER               = "error_user_not_team_owner";
    const ERROR_CANNOT_EDIT_ACCOUNT               = "error_cannot_edit_account";
    const ERROR_ACCOUNT_WITH_EMAIL_ALREADY_EXISTS = "error_account_with_email_already_exists";
    const ERROR_FIELD_DOES_NOT_EXIST              = "error_field_does_not_exist";

    /** API Workspace Management */
    const ERROR_COULD_NOT_CREATE_WORKSPACE  = "error_could_not_create_workspace";
    const ERROR_WORKSPACE_CREATE_PERMISSION = "error_workspace_create_permission";
    const ERROR_WORKSPACE_DOES_NOT_EXIST    = "error_workspace_does_not_exist";
    const ERROR_DELETE_WORKSPACE_PERMISSION = "error_delete_workspace_permission";
    const WARNING_DELETING_WORKSPACE        = "warning_deleting_workspace";
    const ERROR_COULD_NOT_DELETE_WORKSPACE  = "error_could_not_delete_workspace";
    const ERROR_EDIT_WORKSPACE_PERMISSION   = "error_edit_workspace_permission";
    const ERROR_LIST_WORKSPACES_PERMISSION  = "error_list_workspaces_permission";
    const ERROR_VIEW_WORKSPACE_PERMISSION   = "error_view_workspace_permission";
    
    /** API Asset Management */
    const ERROR_COULD_NOT_CREATE_ASSET  = "error_could_not_create_asset";
    const ERROR_ASSET_CREATE_PERMISSION = "error_asset_create_permission";
    const ERROR_ASSET_DOES_NOT_EXIST    = "error_asset_does_not_exist";
    const ERROR_DELETE_ASSET_PERMISSION = "error_delete_asset_permission";
    const WARNING_DELETING_ASSET        = "warning_deleting_asset";
    const ERROR_COULD_NOT_DELETE_ASSET  = "error_could_not_delete_asset";
    const ERROR_EDIT_ASSET_PERMISSION   = "error_asset_permission";
    const ERROR_LIST_ASSETS_PERMISSION  = "error_list_assets_permission";
    
    /** API Permission Management */
    const ERROR_AUTH_USER_NOT_OWNER       = 'error_auth_user_not_owner';
    const ERROR_AUTH_USER_NOT_OWNER_LIST  = 'error_auth_user_not_owner_list';
    const ERROR_COMPONENT_DOES_NOT_EXIST  = 'error_component_does_not_exist';
    const ERROR_PERMISSION_DOES_NOT_EXIST = 'error_permission_does_not_exist';
    
    /** @var Collection */
    public static $commandMessageMap;

    /**
     * Initialise the command message map
     */
    public static function initialise()
    {
        // If the command map is already initialised, no need to initialise it again
        if (static::$commandMessageMap instanceof Collection && !static::$commandMessageMap->isEmpty()) {
            return;
        }

        // Initialise the command message map as a Collection
        $actionNotPermittedMap = new Collection([
            GetUserInformation::class       => static::ERROR_USER_NOT_TEAM_OWNER,
            GetListOfUsersInTeam::class     => static::ERROR_USER_NOT_TEAM_OWNER,
            EditUserAccount::class          => static::ERROR_CANNOT_EDIT_ACCOUNT,
            CreateWorkspace::class          => static::ERROR_WORKSPACE_CREATE_PERMISSION,
            DeleteWorkspace::class          => static::ERROR_DELETE_WORKSPACE_PERMISSION,
            EditWorkspace::class            => static::ERROR_EDIT_WORKSPACE_PERMISSION,
            GetListOfUsersWorkspaces::class => static::ERROR_LIST_WORKSPACES_PERMISSION,
            GetListOfAppsInWorkspace::class => static::ERROR_VIEW_WORKSPACE_PERMISSION,
            GetWorkspace::class             => static::ERROR_VIEW_WORKSPACE_PERMISSION,
            EditAsset::class                => static::ERROR_EDIT_ASSET_PERMISSION,
            DeleteAsset::class              => static::ERROR_DELETE_ASSET_PERMISSION,
            GetAssetsMasterList::class      => static::ERROR_LIST_ASSETS_PERMISSION,
            GetAssetsInWorkspace::class     => static::ERROR_LIST_ASSETS_PERMISSION,
            UpsertPermission::class         => static::ERROR_AUTH_USER_NOT_OWNER,
            RevokePermission::class         => static::ERROR_AUTH_USER_NOT_OWNER,
            GetListOfPermissions::class     => static::ERROR_AUTH_USER_NOT_OWNER_LIST,
        ]);

        static::$commandMessageMap = new Collection([
            ActionNotPermittedException::class => $actionNotPermittedMap,
            InvalidEmailException::class       => static::ERROR_INVALID_EMAIL,
            InvalidInputException::class       => static::ERROR_INVALID_INPUT,
            TeamNotFoundException::class       => static::ERROR_TEAM_DOES_NOT_EXIST,
            UserNotFoundException::class       => static::ERROR_USER_DOES_NOT_EXIST,
            UserNotInTeamException::class      => static::ERROR_TEAM_MEMBER_DOES_NOT_EXIST,
            ORMException::class                => static::ERROR_ACCOUNT_WITH_EMAIL_ALREADY_EXISTS,
            WorkspaceNotFoundException::class  => static::ERROR_WORKSPACE_DOES_NOT_EXIST,
            AssetNotFoundException::class      => static::ERROR_ASSET_DOES_NOT_EXIST,
            ComponentNotFoundException::class  => static::ERROR_COMPONENT_DOES_NOT_EXIST,
            InvalidPermissionException::class  => static::ERROR_PERMISSION_DOES_NOT_EXIST,
        ]);
    }

    /**
     * Get the message key for the translator by the exception and command class
     *
     * @param Exception $exception
     * @param Command $command
     * @return string
     */
    public static function getMessageKeyByExceptionAndCommand($exception, $command)
    {
        try {

            static::initialise();

            // Make sure we got an Exception and Command as arguments.
            // Not using type hinting to avoid Exceptions being thrown in a catch statement, where this
            // method will usually be called from
            if (!($exception instanceof Exception) || !($command instanceof Command)) {
                return static::ERROR_DEFAULT;
            }

            $exceptionClass = get_class($exception);
            $commandClass   = get_class($command);

            // Check that the there is a key for this Exception's class in the map
            if (!static::$commandMessageMap->has($exceptionClass)) {
                return static::ERROR_DEFAULT;
            }

            // If the exception key is a scalar value return it
            if (is_scalar(static::$commandMessageMap->get($exceptionClass))) {
                return static::$commandMessageMap->get($exceptionClass);
            }

            // Extra defensiveness to make sure we don't call the get() method on some other object
            if (!(static::$commandMessageMap->get($exceptionClass) instanceof Collection)) {
                return static::ERROR_DEFAULT;
            }

            // Check that there is a key for this Command's class in the map
            if (!static::$commandMessageMap->get($exceptionClass)->has($commandClass)) {
                return static::ERROR_DEFAULT;
            }

            // We found the message key constant, return it
            return static::$commandMessageMap->get($exceptionClass)->get($commandClass);

        } catch (Exception $e) {
            // This is just being extra defensive, catching any exceptions and returning the default error because
            // this method will usually be called within a catch statement
            return static::ERROR_DEFAULT;
        }
    }
}