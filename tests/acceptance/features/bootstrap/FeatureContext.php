<?php

namespace Tests\Acceptance\Features\Bootstrap;

use App\Exceptions\FeatureBackgroundSetupFailedException;
use App\Exceptions\InvalidConfigurationException;
use App\Team;
use App\User;
use Behat\Behat\Context\Context;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\TableNode;
use Behat\MinkExtension\Context\MinkContext;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\DB;
use Laracasts\Behat\Context\DatabaseTransactions;


/**
 * Defines application features from the specific context.
 */
class FeatureContext extends MinkContext implements Context, SnippetAcceptingContext
{

    /** @var  string */
    protected $apiKey;

    protected $em;

    /**
     * Initializes context.
     * Every scenario gets its own context instance.
     * You can also pass arbitrary arguments to the
     * context constructor through behat.yml.
     */
    public function __construct()
    {
    }

    /**
     * @AfterScenario
     */
    public function truncateTables()
    {
        User::truncate();
        Team::truncate();
    }

    /**
     * @Given /^the following existing ([^"]*):$/
     *
     * @param $objectType
     * @param TableNode $table
     * @return bool
     * @throws FeatureBackgroundSetupFailedException
     * @throws InvalidConfigurationException
     */
    public function theFollowingExistingThings($objectType, TableNode $table)
    {
        $modelClassPath = $this->getEloquentModelClassHelper($objectType);

        /** @var Model $model */
        $model = new $modelClassPath();
        if ($model instanceof Model) {
            foreach ($table as $row) {
                $model = $modelClassPath::forceCreate($row);
                $model->saveOrFail();
            }
            
            return true;
        }

        /*foreach ($table as $row) {
            $model = new $modelClassPath($row);
            app('em')->persist($model);
        }

        app('em')->flush();*/
    }

    /**
     * @Given /^the following ([A-Za-z]*) in ([A-Za-z]*) (.*)$/
     * @param $manyObject
     * @param $oneObject
     * @param $pivotId
     * @param TableNode $table
     */
    public function andTheFollowingRelations($manyObject, $oneObject, $pivotId, TableNode $table)
    {
        $oneClassPath  = $this->getEloquentModelClassHelper($oneObject);
        $manyMethod    = $this->getEloquentManyRelationsMethodHelper($manyObject);

        $oneModel = $oneClassPath::find($pivotId);
        $attachments = [];
        foreach ($table as $row) {
            $row = $this->sanitiseRowHelper($row);
            $id = $row['id'];
            unset($row['id']);
            $attachments[$id] = $row;
        }

        try {
            $oneModel->$manyMethod()->attach($attachments);
        } catch (QueryException $e) {
            // Just catch the exception in the case of integrity constraint violations
        }
    }

    /**
     * Iterate over the columns in a row and convert 'true' or 'false' string values to proper bools
     * @param array $row
     * @return array
     */
    protected function sanitiseRowHelper(array $row)
    {
        if (empty($row)) {
            return $row;
        }

        foreach ($row as $index => $value) {
            if (!is_scalar($value)) {
                continue;
            }

            $row[$index] = $this->convertBoolHelper($value);
        }

        return $row;
    }

    /**
     * Helper method to convert 'true' or 'false' passed as strings from the feature file to proper boolean values
     * @param $value
     * @return bool
     */
    protected function convertBoolHelper($value)
    {
        if ($value === 'true') {
            return true;
        }

        if ($value === 'false') {
            return false;
        }

        if ($value === 'NULL') {
            return null;
        }

        return $value;
    }

    /**
     * Helper method to convert integer values passed as strings from the feature file to proper integer values
     * @param $value
     * @return int
     */
    protected function convertIntHelper($value)
    {
        if (is_int($value)) {
            return intval($value);
        }
        return $value;
    }

    /**
     * Get the full class path for an Eloquent model
     *
     * @param string $objectType
     * @return string
     * @throws FeatureBackgroundSetupFailedException
     * @throws InvalidConfigurationException
     */
    protected function getEloquentModelClassHelper(string $objectType): string
    {
        $rootNamespace = env('APP_MODEL_NAMESPACE');
        if (empty($rootNamespace)) {
            throw new InvalidConfigurationException("Please add APP_MODEL_NAMESPACE to your .env file");
        }

        if (!empty($objectType) && substr($objectType, strlen($objectType) - 1, 1) === "s") {
            $objectType = substr($objectType, 0, strlen($objectType) - 1);
        }

        $modelClassPath = $rootNamespace . "\\" . $objectType;

        if (!class_exists($modelClassPath)) {
            throw new FeatureBackgroundSetupFailedException("The '$modelClassPath' model does not exist.");
        }

        return $modelClassPath;
    }

    /**
     * Get the Eloquent Model method to get the relations for a one-to-many relationship
     *
     * @param string $objectType
     * @return string
     */
    protected function getEloquentManyRelationsMethodHelper(string $objectType): string
    {
        if (!empty($objectType) && substr($objectType, strlen($objectType) - 1, 1) === "s") {
            return strtolower($objectType);
        }

        return strtolower($objectType) . "s";
    }

    /**
     * @Given the following existing users:
     *
    public function theFollowingExistingUsers(TableNode $table)
    {
        foreach ($table as $row) {
            $user = new User($row);
            $user->saveOrFail();
        }
    }*/

    /**
     * @Given the following existing teams:
     *
    public function theFollowingExistingTeams(TableNode $table)
    {
        foreach ($table as $row) {
            $team = new Team($row);
            $team->saveOrFail();
        }
    }*/

    /**
     * @Given a valid API key :apiKey
     */
    public function aValidApiKey($apiKey)
    {
        $this->setApiKey($apiKey);
    }

    /**
     * @return string
     */
    public function getApiKey()
    {
        return $this->apiKey;
    }

    /**
     * @param string $apiKey
     */
    public function setApiKey($apiKey)
    {
        $this->apiKey = $apiKey;
    }
}
