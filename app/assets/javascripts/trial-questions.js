(function(){
  angular.module('TrialQuestionsApp', ['ngSanitize']);

  // questions factory
  angular.module('TrialQuestionsApp').factory('DataService', DataService);

    function DataService($q, $http){

      function getQuestions(quantity) {
        var deferred = $q.defer();

        $http({method: 'GET', url: 'api/v1/questions/sample', params: {quantity: quantity}})
          .success(function(data){
            deferred.resolve(data);
          })
          .error(function(data, status, headers, config){
            deferred.reject('Sorry, questions are not available at the moment.');
          });

        return deferred.promise;
      }

      return {
        getQuestions: getQuestions
      }
  }

  angular.module('TrialQuestionsApp').factory('Quiz', Quiz);

  function Quiz (DataService, $q) {
    var model = this;
    model.currentIndex = 0;
    model.questionNumber = 10;
    model.availableQuestions = []; //we need to populate this from API

    function createNewQuiz() {
      var deferred = $q.defer();

      DataService.getQuestions(model.questionNumber).then(function(data){
        model.availableQuestions = data.questions;
        deferred.resolve(model);
      }, function(reason) {
        console.log('createNew quizcalled with bad response')
        deferred.reject(reason);
      })

      return deferred.promise;
    }

    function currentQuestion(increment) {
      // get the question
      var question = model.availableQuestions[model.currentIndex];
      // prepare the question answers
      question.answers = [];
      question.answers.push({text: question.answer_1, index: 1});
      question.answers.push({text: question.answer_2, index: 2});
      if (question.answer_3 !== null && question.answer_3.length > 0 ) {
        question.answers.push({text: question.answer_3, index: 3});
      }
      if (question.answer_4 !== null && question.answer_4.length > 0) {
        question.answers.push({text: question.answer_4, index: 4});
      }
      if (question.answer_5 !== null && question.answer_5.length > 0) {
        question.answers.push({text: question.answer_5, index: 5});
      }

      // return the question
      return question;
    }

    function lastQuestion() {
      return model.currentIndex == (model.questionNumber - 1)
    }

    function incrementIndex() {
      model.currentIndex += 1;
    }

    function restart() {
      model.currentIndex = 0;
    }

    return {
      createNewQuiz: createNewQuiz,
      currentQuestion: currentQuestion,
      lastQuestion: lastQuestion,
      incrementIndex: incrementIndex,
      restart: restart
    }

  };

  angular.module('TrialQuestionsApp').controller('TrialQuestionsController', TrialQuestionsController);

    // logic for questions
    function TrialQuestionsController($scope, Quiz){
      var vm = this;
      vm.firstQuestionAvailable = false;
      vm.showAnswer = false;
      vm.questionsEnded = false;

      activate();

      function activate() {
        Quiz.createNewQuiz().then(function(quiz){
          vm.currentQuestion = Quiz.currentQuestion();
          vm.firstQuestionAvailable = true;
        }, function(reason) {
          alert(reason);
        })
      }

      vm.selectedAnswer = function(answer){
        answer.selectedAndIncorrect = answer.index != vm.currentQuestion.correct_answer;
        vm.showAnswer = true;

        angular.forEach(vm.currentQuestion.answers, function(answer){
          answer.notSelectedAndIncorrect = true;
        })
      }

      vm.nextQuestion = function() {
        if (Quiz.lastQuestion()) {
          // hide the questions and show the questions ended copy
          vm.firstQuestionAvailable = false;
          vm.questionsEnded = true;
        } else {
          // reset the currentQuestion to the next one in the availableQuestions
          Quiz.incrementIndex();
          vm.currentQuestion = Quiz.currentQuestion();
          vm.showAnswer = false;
        }
      }

      vm.isCorrect = function(answer) {
        return (answer.index == vm.currentQuestion.correct_answer) ? true : false
      }

      vm.startAgain = function(){
        Quiz.restart();
        vm.currentQuestion = Quiz.currentQuestion();

        vm.showAnswer = false;
        vm.questionsEnded = false
        vm.firstQuestionAvailable = true;
      }

  }
})();