<template>
    <div class="login-page">
        <div class="hng-brand">HNG.TECH</div>
        <div class="container">
            <spinner v-show="loggingIn" message="Logging in..."></spinner>
            <form class="form-horizontal login-form" role="form" v-on:submit.prevent="doLogin">
                <div class="row text-center">
                    <div class="col-md-12">
                        <h2>Welcome to HNG13 DevOps Stage Six Task</h2>
                        <hr class="custom-hr" />
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="sr-only" for="username">Username</label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"><i class="fa fa-user"></i></span>
                                </div>
                                <input
                                    type="text"
                                    name="username"
                                    class="form-control"
                                    placeholder="Enter your username"
                                    v-model="credentials.username"
                                    required
                                    autofocus
                                />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="sr-only" for="password">Password</label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"><i class="fa fa-lock"></i></span>
                                </div>
                                <input
                                    type="password"
                                    name="password"
                                    class="form-control"
                                    placeholder="Enter your password"
                                    v-model="credentials.password"
                                    required
                                />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="col-md-6 text-danger text-center">
                        <small>{{ errorMessage }}</small>
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="col-md-6 text-center">
                        <button type="submit" class="btn btn-primary btn-block">
                            <i class="fa fa-sign-in"></i> Login
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
import Spinner from '@/components/common/Spinner'
import AppNav from '@/components/AppNav'

export default {
  name: 'login',
  components: { AppNav, Spinner },
  methods: {
    doLogin () {
      this.loggingIn = true
      this.errorMessage = ''

      const credentials = {
        username: this.credentials.username,
        password: this.credentials.password
      }

      this.$auth.login(credentials, 'todos').then((response) => {
        this.loggingIn = false
        this.errorMessage = response.body.message
      })
    }
  },
  data () {
    return {
      credentials: {
        username: '',
        password: ''
      },
      errorMessage: '',
      loggingIn: false
    }
  }
}
</script>

<style scoped>
.login-page {
    min-height: 100vh;
    background: #f8f9fa;
    padding: 20px;
    position: relative;
}

.hng-brand {
    position: fixed;
    top: 20px;
    right: 30px;
    color: #0056b3;
    font-weight: bold;
    font-size: 24px;
    z-index: 1000;
}

.container {
    margin-top: 50px;
}

h2 {
    color: #0056b3;
}

.custom-hr {
    border: 2px solid #0056b3;
    width: 50%;
    margin: 15px auto;
}

.login-form {
    background: #fff;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.input-group-text {
    background-color: #0056b3;
    color: #fff;
    border: none;
}

.form-control {
    border: 1px solid #ced4da;
}

.btn-primary {
    background-color: #0056b3;
    border-color: #0056b3;
}

.btn-primary:hover {
    background-color: #003f7f;
    border-color: #003f7f;
}

.text-danger {
    font-size: 0.9em;
    margin-top: 5px;
}
</style>
