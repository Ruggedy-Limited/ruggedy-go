<?php

namespace App\Transformers;

use App\Entities\File;
use App\Entities\Vulnerability;
use League\Fractal\TransformerAbstract;

class FileTransformer extends TransformerAbstract
{
    /**
     * List of resources possible to include
     *
     * @var array
     */
    protected $availableIncludes = [
        'assets',
        'audits',
        'comments',
        'exploits',
        'openPorts',
        'softwareInformation',
        'vulnerabilities',
    ];

     /**
     * Transform a File entity for the API
     *
     * @param File $file
     * @return array
     */
    public function transform(File $file)
    {
        return [
            'id'           => $file->getId(),
            'filename'     => basename($file->getPath()),
            'format'       => $file->getFormat(),
            'size'         => $file->getSize(),
            'scannerId'    => $file->getWorkspaceApp()->getScannerApp()->getId(),
            'scannerName'  => $file->getWorkspaceApp()->getScannerApp()->getName(),
            'workspaceId'  => $file->getWorkspaceApp()->getWorkspace()->getId(),
            'ownerId'      => $file->getUser()->getId(),
            'isProcessed'  => $file->getProcessed(),
            'isDeleted'    => $file->getDeleted(),
            'createdDate'  => $file->getCreatedAt()->format(env('APP_DATE_FORMAT')),
            'modifiedDate' => $file->getUpdatedAt()->format(env('APP_DATE_FORMAT')),
        ];
    }

    /**
     * Optional include for Assets
     *
     * @param File $file
     * @return \League\Fractal\Resource\Collection
     */
    public function includeAssets(File $file)
    {
        return $this->collection($file->getAssets(), new AssetTransformer());
    }

    /**
     * Optional include for Audits
     *
     * @param File $file
     * @return \League\Fractal\Resource\Collection
     */
    public function includeAudits(File $file)
    {
        return $this->collection($file->getAudits(), new AuditTransformer());
    }

    /**
     * Optional include for Comments
     *
     * @param File $file
     * @return \League\Fractal\Resource\Collection
     */
    public function includeComments(File $file)
    {
        return $this->collection($file->getComments(), new CommentTransformer());
    }

    /**
     * Optional include for Exploits
     *
     * @param File $file
     * @return \League\Fractal\Resource\Collection
     */
    public function includeExploits(File $file)
    {
        $exploits = collect($file->getVulnerabilities()->toArray())->flatMap(function ($vulnerability) {
            /** @var Vulnerability $vulnerability */
            return collect($vulnerability->getExploits()->toArray());
        });

        return $this->collection($exploits, new ExploitTransformer());
    }

    /**
     * Optional include for Open Ports
     *
     * @param File $file
     * @return \League\Fractal\Resource\Collection
     */
    public function includeOpenPorts(File $file)
    {
        return $this->collection($file->getOpenPorts(), new OpenPortTransformer());
    }

    /**
     * Optional include for Software Information
     *
     * @param File $file
     * @return \League\Fractal\Resource\Collection
     */
    public function includeSoftwareInformation(File $file)
    {
        return $this->collection($file->getSoftwareInformation(), new SoftwareInformationTransformer());
    }

    /**
     * Optional include for Vulnerabilities
     *
     * @param File $file
     * @return \League\Fractal\Resource\Collection
     */
    public function includeVulnerabilities(File $file)
    {
        return $this->collection($file->getVulnerabilities(), new VulnerabilityTransformer());
    }
}