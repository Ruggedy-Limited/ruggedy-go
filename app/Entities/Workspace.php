<?php

namespace App\Entities;

use App\Contracts\SystemComponent;
use Doctrine\ORM\Mapping as ORM;
use Illuminate\Support\Collection;

/**
 * App\Entities\Workspace
 *
 * @ORM\Entity(repositoryClass="App\Repositories\WorkspaceRepository")
 * @ORM\HasLifecycleCallbacks
 */
class Workspace extends Base\Workspace implements SystemComponent
{
    /**
     * @ORM\ManyToOne(targetEntity="User", inversedBy="workspaces", cascade={"persist"}, fetch="EAGER")
     * @ORM\JoinColumn(name="`user_id`", referencedColumnName="`id`", nullable=false)
     */
    protected $user;

    /**
     * Get the parent Entity of this Entity
     *
     * @return Base\User
     */
    public function getParent()
    {
        return $this->user;
    }

    /**
     * Get all the Assets in this Workspace
     *
     * @return Collection
     */
    public function getAssets()
    {
        return collect($this->getFiles()->toArray())
            // Merge the Assets related to each file into a single Collection of Assets for the Workspace
            ->reduce(function ($assets, $file) {
                /** @var File $file */
                /** @var Collection $assets */
                return $assets->merge($file->getAssets()->toArray());
            }, new Collection())
            // Filter out any suppressed or deleted Assets
            ->filter(function($asset) {
                /** @var $asset Asset */
                // Exclude deleted Assets
                return $asset->getDeleted() !== true && $asset->getSuppressed() !== true;
        });
    }
}