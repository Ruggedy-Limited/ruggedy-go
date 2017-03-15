<?php

namespace App\Handlers\Commands;

use App\Commands\GetFile as GetFileCommand;
use App\Entities\Asset;
use App\Entities\File;
use App\Exceptions\ActionNotPermittedException;
use App\Exceptions\FileNotFoundException;
use App\Policies\ComponentPolicy;
use App\Repositories\FileRepository;

class GetFile extends CommandHandler
{
    /** @var FileRepository */
    protected $fileRepository;

    /**
     * GetFile constructor.
     *
     * @param FileRepository $fileRepository
     */
    public function __construct(FileRepository $fileRepository)
    {
        $this->fileRepository = $fileRepository;
    }

    /**
     * Process the GetFile command.
     *
     * @param GetFileCommand $command
     * @return File
     * @throws ActionNotPermittedException
     * @throws FileNotFoundException
     */
    public function handle(GetFileCommand $command)
    {
        $requestingUser = $this->authenticate();

        /** @var File $file */
        $file = $this->fileRepository->find($command->getId());
        if (empty($file)) {
            throw new FileNotFoundException("No file with the given ID was found.");
        }

        if ($requestingUser->cannot(ComponentPolicy::ACTION_VIEW, $file->getWorkspaceApp()->getWorkspace())) {
            throw new ActionNotPermittedException("The requesting User is not permitted to view this file.");
        }

        $fileVulnerabilities = collect($file->getVulnerabilities()->toArray());
        $file->getAssets()->forAll(function ($_, $asset) use ($fileVulnerabilities) {
            /** @var Asset $asset */
            collect($asset->getVulnerabilities()->toArray())
                ->diff($fileVulnerabilities)
                ->each(function ($vulnerability) use ($asset) {
                    $asset->removeVulnerability($vulnerability);
                });

            return true;
        });

        return $file;
    }
}