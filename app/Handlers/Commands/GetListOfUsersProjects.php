<?php

namespace App\Handlers\Commands;

use App\Commands\GetListOfUsersProjects as GetListOfUsersProjectsCommand;
use App\Entities\User;
use App\Exceptions\ActionNotPermittedException;
use App\Exceptions\InvalidInputException;
use App\Exceptions\UserNotFoundException;
use App\Repositories\UserRepository;
use Exception;
use Illuminate\Support\Facades\Auth;


class GetListOfUsersProjects extends CommandHandler
{
    /** @var UserRepository */
    protected $userRepository;

    /**
     * GetListOfUsersProjects constructor.
     *
     * @param UserRepository $userRepository
     */
    public function __construct(UserRepository $userRepository)
    {
        $this->userRepository = $userRepository;
    }

    /**
     * Process the GetListOfUsersProjects command
     *
     * @param GetListOfUsersProjectsCommand $command
     * @return array
     * @throws ActionNotPermittedException
     * @throws Exception
     * @throws InvalidInputException
     * @throws UserNotFoundException
     */
    public function handle(GetListOfUsersProjectsCommand $command)
    {
        // Get the authenticated User
        /** @var User $requestingUser */
        $requestingUser = Auth::user();
        if (empty($requestingUser)) {
            throw new Exception("Could not get authenticated User");
        }

        // Make sure all the required members are set on the command
        $userId = $command->getId();
        if (!isset($userId)) {
            throw new InvalidInputException("The required User ID was not set on the given command");
        }

        /** @var User $user */
        $user = $this->getUserRepository()->find($userId);
        if (empty($user)) {
            throw new UserNotFoundException("A User related to the given User ID was not found");
        }

        // Make sure the User has permission to list these projects
        if ($requestingUser->getId() !== $user->getId()) {
            throw new ActionNotPermittedException("The authenticated User does not have permission to list those Projects");
        }

        return $user->getProjects()->toArray();

    }

    /**
     * @return UserRepository
     */
    public function getUserRepository()
    {
        return $this->userRepository;
    }

    /**
     * @param UserRepository $userRepository
     */
    public function setUserRepository($userRepository)
    {
        $this->userRepository = $userRepository;
    }
}