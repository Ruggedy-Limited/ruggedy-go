<?php

namespace App\Models;

use App\Entities\OpenPort;
use Illuminate\Support\Collection;

class PortModel
{
    /** @var int */
    protected $portId;

    /** @var string */
    protected $protocol;

    /** @var string */
    protected $serviceName;

    /** @var string */
    protected $serviceProduct;

    /** @var string */
    protected $serviceExtraInformation;

    /** @var string */
    protected $serviceFingerPrint;

    /** @var string */
    protected $serviceBanner;

    /**
     * @return int
     */
    public function getPortId(): int
    {
        return $this->portId;
    }

    /**
     * @param int $portId
     */
    public function setPortId(int $portId)
    {
        $this->portId = $portId;
    }

    /**
     * @return string
     */
    public function getProtocol()
    {
        return $this->protocol;
    }

    /**
     * @param string $protocol
     */
    public function setProtocol(string $protocol)
    {
        $this->protocol = $protocol;
    }

    /**
     * @return string
     */
    public function getServiceName()
    {
        return $this->serviceName;
    }

    /**
     * @param string $serviceName
     */
    public function setServiceName(string $serviceName)
    {
        $this->serviceName = $serviceName;
    }

    /**
     * @return string
     */
    public function getServiceProduct()
    {
        return $this->serviceProduct;
    }

    /**
     * @param string $serviceProduct
     */
    public function setServiceProduct(string $serviceProduct)
    {
        $this->serviceProduct = $serviceProduct;
    }

    /**
     * @return string
     */
    public function getServiceExtraInformation()
    {
        return $this->serviceExtraInformation;
    }

    /**
     * @param string $serviceExtraInformation
     */
    public function setServiceExtraInformation(string $serviceExtraInformation)
    {
        $this->serviceExtraInformation = $serviceExtraInformation;
    }

    /**
     * @return string
     */
    public function getServiceFingerPrint()
    {
        return $this->serviceFingerPrint;
    }

    /**
     * @param string $serviceFingerPrint
     */
    public function setServiceFingerPrint(string $serviceFingerPrint)
    {
        $this->serviceFingerPrint = $serviceFingerPrint;
    }

    /**
     * @return string
     */
    public function getServiceBanner()
    {
        return $this->serviceBanner;
    }

    /**
     * @param string $serviceBanner
     */
    public function setServiceBanner(string $serviceBanner)
    {
        $this->serviceBanner = $serviceBanner;
    }

    /**
     * Export the model data to be used to create an OpenPort Entity
     *
     * @return Collection
     */
    public function export()
    {
        return new Collection([
            OpenPort::NUMBER               => $this->getPortId(),
            OpenPort::PROTOCOL             => strtoupper($this->getProtocol()),
            OpenPort::SERVICE_NAME         => strtoupper($this->getServiceName()),
            OpenPort::SERVICE_PRODUCT      => $this->getServiceProduct(),
            OpenPort::SERVICE_EXTRA_INFO   => $this->getServiceExtraInformation(),
            OpenPort::SERVICE_FINGER_PRINT => $this->getServiceFingerPrint(),
            OpenPort::SERVICE_BANNER       => $this->getServiceBanner(),
        ]);
    }
}