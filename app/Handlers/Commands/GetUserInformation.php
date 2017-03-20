<?php

namespace App\Handlers\Commands;

use App\Commands\GetUserInformation as GetUserInformationCommand;
use App\Entities\Team;
use App\Entities\User;
use App\Exceptions\ActionNotPermittedException;
use App\Exceptions\InvalidInputException;
use App\Exceptions\TeamNotFoundException;
use App\Exceptions\UserNotFoundException;
use App\Exceptions\UserNotInTeamException;
use App\Policies\ComponentPolicy;
use App\Repositories\TeamRepository;
use App\Repositories\UserRepository;
use Doctrine\ORM\EntityManager;
use Exception;

class GetUserInformation extends CommandHandler
{
    /** @var TeamRepository  */
    protected $teamRepository;
    
    /** @var UserRepository  */
    protected $userRepository;
    
    /** @var EntityManager  */
    protected $em;

    /**
     * GetUserInformation constructor.
     *
     * @param TeamRepository $teamRepository
     * @param UserRepository $userRepository
     * @param EntityManager $em
     */
    public function __construct(TeamRepository $teamRepository, UserRepository $userRepository, EntityManager $em)
    {
        $this->teamRepository = $teamRepository;
        $this->userRepository = $userRepository;
        $this->em             = $em;
    }

    /**
     * Process the GetUserInformation command
     *
     * @param GetUserInformationCommand $command
     * @return User
     * @throws ActionNotPermittedException
     * @throws Exception
     * @throws InvalidInputException
     * @throws TeamNotFoundException
     * @throws UserNotFoundException
     * @throws UserNotInTeamException
     */
    public function handle(GetUserInformationCommand $command)
    {
        // Get the authenticated user
        $requestingUser = $this->authenticate();

        // Make sure all the required members are set on the command
        $teamId = $command->getTeamId();
        $userId = $command->getUserId();
        if (!isset($teamId, $userId)) {
            throw new InvalidInputException("Both a valid team ID and user ID are required");
        }

        // Make sure the user exists
        /** @var User $queriedUser */
        $queriedUser = $this->userRepository->find($userId);
        if (empty($queriedUser)) {
            throw new UserNotFoundException("No User with the given ID was found in the database");
        }

        // Make sure the team exists
        /** @var Team $team */
        $team = $this->teamRepository->find($teamId);
        if (empty($team)) {
            throw new TeamNotFoundException("No Team with the given ID was found in the database");
        }

        // Make sure that the user own the given team
        if (!$requestingUser->can(ComponentPolicy::ACTION_VIEW, $team)) {
            throw new ActionNotPermittedException(
                "The authenticated user does not have permission to view this person's information"
            );
        }

        // Make sure the given user is on the team
        if (empty($team->personIsInTeam($queriedUser))) {
            throw new UserNotInTeamException("The given User is not part of the given Team");
        }

        return $queriedUser;
    }

    /**
     * @return TeamRepository
     */
    public function getTeamRepository()
    {
        return $this->teamRepository;
    }

    /**
     * @param TeamRepository $teamRepository
     */
    public function setTeamRepository($teamRepository)
    {
        $this->teamRepository = $teamRepository;
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

    /**
     * @return EntityManager
     */
    public function getEm()
    {
        return $this->em;
    }

    /**
     * @param EntityManager $em
     */
    public function setEm($em)
    {
        $this->em = $em;
    }
}